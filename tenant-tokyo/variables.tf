variable "compartment_ocid" {
  description = "OCID of the root compartment (or sub-compartment) for this tenant"
  type        = string
}

variable "availability_domain" {
  description = "Availability domain name for Tokyo"
  type        = string
}

variable "ssh_public_key_path" {
  description = "Path to your SSH public key file"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "ubuntu2404_x86_image_id" {
  description = "OCID of Ubuntu 24.04 x86_64 image in ap-tokyo-1"
  type        = string
}

variable "ubuntu2404_arm_image_id" {
  description = "OCID of Ubuntu 24.04 aarch64 image in ap-tokyo-1"
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

variable "extra_tcp_ports" {
  description = "Additional TCP ports to open inbound from 0.0.0.0/0"
  type        = list(number)
  default     = []
}

variable "extra_udp_ports" {
  description = "Additional UDP ports to open inbound from 0.0.0.0/0"
  type        = list(number)
  default     = []
}

variable "extra_proto_numbers" {
  description = "Additional IP protocol numbers to allow inbound (e.g. 50 for ESP)"
  type        = list(number)
  default     = []
}
