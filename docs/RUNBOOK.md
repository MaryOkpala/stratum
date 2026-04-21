# Stratum — Operations Runbook

## Prerequisites

| Tool | Version | Install |
|------|---------|---------|
| Terraform | >= 1.0 | https://developer.hashicorp.com/terraform/install |
| Ansible | >= 2.15 | `brew install ansible` |
| AWS CLI | >= 2.0 | `brew install awscli` |

## Initial setup

```bash
# Configure AWS credentials
aws configure

# Clone the repository
git clone https://github.com/MaryOkpala/stratum.git
cd stratum

# Create your SSH key pair
aws ec2 create-key-pair \
  --key-name stratum-key \
  --query 'KeyMaterial' \
  --output text \
  --region us-east-1 > ~/.ssh/stratum-key.pem
chmod 400 ~/.ssh/stratum-key.pem
```

## Provision infrastructure

```bash
# Copy and configure variables
cd terraform/environments/dev
cp example.tfvars terraform.tfvars
# Edit terraform.tfvars — set your_ip and key_name

# Initialise Terraform
terraform init

# Preview changes
terraform plan

# Apply
terraform apply
```

## Configure servers

```bash
# Update inventory with Terraform outputs
BASTION=$(terraform output -raw bastion_public_ip)
WEB=$(terraform output -raw web_public_ip)
APP=$(terraform output -raw app_private_ip)

# Run full configuration
cd ../../../ansible
ansible-playbook -i inventory/hosts playbooks/site.yml
```

## Verify deployment

```bash
# Test all servers reachable
ansible all -i inventory/hosts -m ping

# Test full stack end to end
curl http://<web_public_ip>/stratum/index.html

# Check Nginx status on web tier
ansible web -i inventory/hosts -m shell -a "systemctl status nginx" --become

# Check Tomcat status on app tier
ansible app -i inventory/hosts -m shell -a "systemctl status tomcat" --become
```

## Access servers

```bash
# SSH to bastion
ssh -i ~/.ssh/stratum-key.pem ubuntu@<bastion_ip>

# SSH to web (direct)
ssh -i ~/.ssh/stratum-key.pem ubuntu@<web_ip>

# SSH to app (via bastion)
ssh -i ~/.ssh/stratum-key.pem \
  -o ProxyCommand="ssh -W %h:%p -i ~/.ssh/stratum-key.pem ubuntu@<bastion_ip>" \
  ubuntu@<app_private_ip>
```

## Destroy everything

```bash
cd terraform/environments/dev
terraform destroy
```
Stop instances when not in use. NAT Gateway incurs hourly charges even when idle — run `terraform destroy` when done showcasing.
