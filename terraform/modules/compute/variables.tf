variable "project" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for EC2 instances"
  type        = string
}

variable "public_subnet_id" {
  description = "Public subnet ID"
  type        = string
}

variable "private_subnet_id" {
  description = "Private subnet ID"
  type        = string
}

variable "bastion_sg_id" {
  description = "Bastion security group ID"
  type        = string
}

variable "web_sg_id" {
  description = "Web tier security group ID"
  type        = string
}

variable "app_sg_id" {
  description = "App tier security group ID"
  type        = string
}

variable "key_name" {
  description = "EC2 key pair name"
  type        = string
}
