output "bastion_sg_id" {
  description = "Bastion security group ID"
  value       = aws_security_group.bastion.id
}

output "web_sg_id" {
  description = "Web tier security group ID"
  value       = aws_security_group.web.id
}

output "app_sg_id" {
  description = "App tier security group ID"
  value       = aws_security_group.app.id
}
