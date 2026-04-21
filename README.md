# Stratum

> Fully automated multi-tier AWS infrastructure provisioning and configuration — from zero to a running application with a single command.

## What this project does

Stratum provisions a complete, production-style AWS environment entirely from code:

- **Terraform** creates all AWS resources — VPC, subnets, internet gateway, NAT gateway, route tables, security groups, and EC2 instances across three tiers
- **Ansible** configures every server — OS hardening, Nginx reverse proxy on the web tier, Java and Tomcat on the app tier
- **Remote state** stored in S3 with DynamoDB locking — safe for team use

Zero manual console clicks. Everything is versioned, repeatable, and idempotent.

## Architecture

![Stratum Architecture](docs/architecture.png)

## Stack

| Tool | Role |
|------|------|
| Terraform 1.7+ | Infrastructure provisioning |
| Ansible 2.15+ | Configuration management |
| AWS VPC | Network isolation |
| AWS EC2 | Compute — bastion, web, app tiers |
| AWS S3 | Terraform remote state storage |
| AWS DynamoDB | State locking |
| Nginx | Reverse proxy on web tier |
| Tomcat + Java 17 | Application server on app tier |

## Infrastructure layout
Internet → IGW → Public subnet (10.0.1.0/24)
├── Bastion host (t3.micro) — SSH jump server
└── Web tier (t3.small)    — Nginx, public IP
Private subnet (10.0.2.0/24) → NAT → Internet
                └── App tier (t3.small)    — Tomcat, no public IP
## Quick start

```bash
# 1. Provision infrastructure
cd terraform/environments/dev
cp example.tfvars terraform.tfvars
# Edit terraform.tfvars with your values
terraform init
terraform plan
terraform apply

# 2. Generate Ansible inventory
terraform output ansible_inventory > ../../../ansible/inventory/hosts

# 3. Configure all servers
cd ../../../ansible
ansible-playbook -i inventory/hosts playbooks/site.yml
```

## Destroy everything

```bash
cd terraform/environments/dev
terraform destroy
```
