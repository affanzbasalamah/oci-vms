output "amd_public_ip" {
  description = "Public IP of the Sydney AMD x86_64 VM"
  value       = module.vm.amd_public_ip
}

output "a1_public_ip" {
  description = "Public IP of the Sydney Ampere A1 aarch64 VM"
  value       = module.vm.a1_public_ip
}

output "amd_instance_id" {
  value = module.vm.amd_instance_id
}

output "a1_instance_id" {
  value = module.vm.a1_instance_id
}
