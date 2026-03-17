# ── VCN ─────────────────────────────────────────────────────────────────────

resource "oci_core_vcn" "this" {
  compartment_id = var.compartment_ocid
  cidr_block     = var.vcn_cidr
  display_name   = "${var.label_prefix}-vcn"
  dns_label      = "${var.label_prefix}vcn"
}

# ── Internet Gateway ─────────────────────────────────────────────────────────

resource "oci_core_internet_gateway" "this" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.this.id
  display_name   = "${var.label_prefix}-igw"
  enabled        = true
}

# ── Route Table ──────────────────────────────────────────────────────────────

resource "oci_core_route_table" "this" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.this.id
  display_name   = "${var.label_prefix}-rt"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.this.id
  }
}

# ── Security List ─────────────────────────────────────────────────────────────

resource "oci_core_security_list" "this" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.this.id
  display_name   = "${var.label_prefix}-sl"

  # Allow all outbound
  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "all"
  }

  # Allow SSH inbound
  ingress_security_rules {
    protocol = "6" # TCP
    source   = "0.0.0.0/0"
    tcp_options {
      min = 22
      max = 22
    }
  }

  # Allow ICMP (ping)
  ingress_security_rules {
    protocol = "1" # ICMP
    source   = "0.0.0.0/0"
    icmp_options {
      type = 3
      code = 4
    }
  }
}

# ── Public Subnet ─────────────────────────────────────────────────────────────

resource "oci_core_subnet" "this" {
  compartment_id    = var.compartment_ocid
  vcn_id            = oci_core_vcn.this.id
  cidr_block        = var.subnet_cidr
  display_name      = "${var.label_prefix}-subnet"
  dns_label         = "${var.label_prefix}sub"
  route_table_id    = oci_core_route_table.this.id
  security_list_ids = [oci_core_security_list.this.id]
}

# ── AMD x86_64 VM (VM.Standard.E2.1.Micro — always-free) ─────────────────────

resource "oci_core_instance" "amd" {
  compartment_id      = var.compartment_ocid
  availability_domain = var.availability_domain
  display_name        = var.amd_vm_name
  shape               = "VM.Standard.E2.1.Micro"

  source_details {
    source_type = "image"
    source_id   = var.ubuntu2404_x86_image_id
  }

  create_vnic_details {
    subnet_id        = oci_core_subnet.this.id
    assign_public_ip = true
    display_name     = "${var.amd_vm_name}-vnic"
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key
  }

  preserve_boot_volume = false
}

# ── Ampere A1 aarch64 VM (VM.Standard.A1.Flex — always-free) ─────────────────

resource "oci_core_instance" "a1" {
  compartment_id      = var.compartment_ocid
  availability_domain = var.availability_domain
  display_name        = var.a1_vm_name
  shape               = "VM.Standard.A1.Flex"

  shape_config {
    ocpus         = var.a1_ocpus
    memory_in_gbs = var.a1_memory_in_gbs
  }

  source_details {
    source_type = "image"
    source_id   = var.ubuntu2404_arm_image_id
  }

  create_vnic_details {
    subnet_id        = oci_core_subnet.this.id
    assign_public_ip = true
    display_name     = "${var.a1_vm_name}-vnic"
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key
  }

  preserve_boot_volume = false
}
