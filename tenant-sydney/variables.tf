variable "compartment_ocid" {
  description = "OCID of the root compartment (or sub-compartment) for this tenant"
  type        = string
}

variable "availability_domain" {
  description = "Availability domain name for Sydney"
  type        = string
}

variable "ssh_public_key_path" {
  description = "Path to your SSH public key file"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "ubuntu2404_x86_image_id" {
  description = "OCID of Ubuntu 24.04 x86_64 image in ap-sydney-1"
  type        = string
}

variable "ubuntu2404_arm_image_id" {
  description = "OCID of Ubuntu 24.04 aarch64 image in ap-sydney-1"
  type        = string
}

variable "a1_ocpus" {
  type    = number
  default = 2
}

variable "a1_memory_in_gbs" {
  type    = number
  default = 12
}
