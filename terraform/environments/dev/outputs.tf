output "vpc_id" {
  description = "VPC ID"
  value       = module.networking.vpc_id
}

output "bastion_public_ip" {
  description = "Bastion host public IP"
  value       = module.compute.bastion_public_ip
}

output "web_public_ip" {
  description = "Web tier public IP"
  value       = module.compute.web_public_ip
}

output "app_private_ip" {
  description = "App tier private IP"
  value       = module.compute.app_private_ip
}
