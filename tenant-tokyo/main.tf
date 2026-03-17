module "vm" {
  source = "../modules/vm"

  compartment_ocid    = var.compartment_ocid
  availability_domain = var.availability_domain
  ssh_public_key      = file(var.ssh_public_key_path)
  label_prefix        = "jp"

  # AMD free-tier VM
  amd_vm_name             = "jp-amd-vm"
  ubuntu2404_x86_image_id = var.ubuntu2404_x86_image_id

  # Ampere A1 free-tier VM
  a1_vm_name              = "jp-a1-vm"
  ubuntu2404_arm_image_id = var.ubuntu2404_arm_image_id
  a1_ocpus                = var.a1_ocpus
  a1_memory_in_gbs        = var.a1_memory_in_gbs
}
