#!/bin/bash
set -e

echo "=== Project Stratum — Full Provisioning ==="
echo ""

echo "Step 1: Terraform apply..."
cd terraform/environments/dev
terraform apply -auto-approve

echo ""
echo "Step 2: Generating Ansible inventory..."
BASTION_IP=$(terraform output -raw bastion_public_ip)
WEB_IP=$(terraform output -raw web_public_ip)
APP_IP=$(terraform output -raw app_private_ip)

cat > ../../../ansible/inventory/hosts << INVENTORY
[bastion]
bastion ansible_host=${BASTION_IP} ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/stratum-key.pem

[web]
web ansible_host=${WEB_IP} ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/stratum-key.pem ansible_ssh_common_args='-o StrictHostKeyChecking=no'

[app]
app ansible_host=${APP_IP} ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/stratum-key.pem ansible_ssh_common_args='-o StrictHostKeyChecking=no -o ProxyCommand="ssh -W %h:%p -i ~/.ssh/stratum-key.pem -o StrictHostKeyChecking=no ubuntu@${BASTION_IP}"'

[all:vars]
ansible_python_interpreter=/usr/bin/python3
INVENTORY

echo ""
echo "Step 3: Running Ansible playbooks..."
cd ../../../
ansible-playbook -i ansible/inventory/hosts ansible/playbooks/site.yml

echo ""
echo "=== Provisioning complete ==="
echo "Web tier: http://${WEB_IP}"
echo "App tier: http://${WEB_IP}/stratum-app (via Nginx proxy)"
