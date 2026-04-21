terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
    bucket         = "stratum-terraform-state-007448416489"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "stratum-terraform-locks"
    encrypt        = true
  }
}

provider "aws" {
  region = var.aws_region
  default_tags {
    tags = {
      Project     = "Stratum"
      Environment = var.environment
      ManagedBy   = "Terraform"
      Owner       = "MaryOkpala"
    }
  }
}

module "networking" {
  source              = "../../modules/networking"
  project             = var.project
  environment         = var.environment
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidr  = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
  availability_zone   = var.availability_zone
}

module "security" {
  source      = "../../modules/security"
  project     = var.project
  environment = var.environment
  vpc_id      = module.networking.vpc_id
  your_ip     = var.your_ip
}

module "compute" {
  source            = "../../modules/compute"
  project           = var.project
  environment       = var.environment
  ami_id            = var.ami_id
  public_subnet_id  = module.networking.public_subnet_id
  private_subnet_id = module.networking.private_subnet_id
  bastion_sg_id     = module.security.bastion_sg_id
  web_sg_id         = module.security.web_sg_id
  app_sg_id         = module.security.app_sg_id
  key_name          = var.key_name
}
