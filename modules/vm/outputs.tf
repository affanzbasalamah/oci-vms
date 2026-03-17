output "amd_instance_id" {
  description = "OCID of the AMD x86_64 instance"
  value       = oci_core_instance.amd.id
}

output "amd_public_ip" {
  description = "Public IP address of the AMD x86_64 instance"
  value       = oci_core_instance.amd.public_ip
}

output "a1_instance_id" {
  description = "OCID of the Ampere A1 aarch64 instance"
  value       = oci_core_instance.a1.id
}

output "a1_public_ip" {
  description = "Public IP address of the Ampere A1 aarch64 instance"
  value       = oci_core_instance.a1.public_ip
}

output "vcn_id" {
  description = "OCID of the VCN"
  value       = oci_core_vcn.this.id
}
