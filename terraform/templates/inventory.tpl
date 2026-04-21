[bastion]
bastion ansible_host=${bastion_ip} ansible_user=ubuntu ansible_ssh_private_key_file=${key_path}

[web]
web ansible_host=${web_ip} ansible_user=ubuntu ansible_ssh_private_key_file=${key_path} ansible_ssh_common_args='-o StrictHostKeyChecking=no'

[app]
app ansible_host=${app_ip} ansible_user=ubuntu ansible_ssh_private_key_file=${key_path} ansible_ssh_common_args='-o ProxyJump=ubuntu@${bastion_ip} -o StrictHostKeyChecking=no'

[all:vars]
ansible_python_interpreter=/usr/bin/python3
