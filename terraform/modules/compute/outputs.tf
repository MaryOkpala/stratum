output "bastion_public_ip" {
  description = "Bastion host public IP"
  value       = aws_instance.bastion.public_ip
}

output "web_public_ip" {
  description = "Web tier public IP"
  value       = aws_instance.web.public_ip
}

output "app_private_ip" {
  description = "App tier private IP"
  value       = aws_instance.app.private_ip
}

output "bastion_instance_id" {
  description = "Bastion instance ID"
  value       = aws_instance.bastion.id
}

output "web_instance_id" {
  description = "Web instance ID"
  value       = aws_instance.web.id
}

output "app_instance_id" {
  description = "App instance ID"
  value       = aws_instance.app.id
}
