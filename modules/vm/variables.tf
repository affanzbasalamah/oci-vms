variable "compartment_ocid" {
  description = "OCID of the compartment to deploy resources into"
  type        = string
}

variable "availability_domain" {
  description = "Availability domain name (e.g. xxxx:AP-SINGAPORE-1-AD-1)"
  type        = string
}

variable "ssh_public_key" {
  description = "SSH public key string for instance access"
  type        = string
}

# ── AMD VM (VM.Standard.E2.1.Micro — always-free x86_64) ────────────────────

variable "amd_vm_name" {
  description = "Display name for the AMD x86_64 instance"
  type        = string
  default     = "amd-vm"
}

variable "ubuntu2404_x86_image_id" {
  description = "OCID of Ubuntu 24.04 x86_64 image in this region"
  type        = string
}

# E2.1.Micro is a fixed shape: 1 OCPU, 1 GB RAM — no flex parameters needed

# ── Ampere A1 VM (VM.Standard.A1.Flex — always-free aarch64) ────────────────

variable "a1_vm_name" {
  description = "Display name for the Ampere A1 aarch64 instance"
  type        = string
  default     = "a1-vm"
}

variable "ubuntu2404_arm_image_id" {
  description = "OCID of Ubuntu 24.04 aarch64 image in this region"
  type        = string
}

variable "a1_ocpus" {
  description = "Number of OCPUs for the A1.Flex instance (max free: 4 total per tenancy)"
  type        = number
  default     = 2
}

variable "a1_memory_in_gbs" {
  description = "Memory in GB for the A1.Flex instance (max free: 24 GB total per tenancy)"
  type        = number
  default     = 12
}

# ── Networking ───────────────────────────────────────────────────────────────

variable "vcn_cidr" {
  description = "CIDR block for the VCN"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "label_prefix" {
  description = "Short prefix for naming all resources (e.g. 'sg', 'au', 'jp')"
  type        = string
  default     = "oci"
}
