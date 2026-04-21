resource "aws_instance" "bastion" {
  ami                         = var.ami_id
  instance_type               = "t3.micro"
  subnet_id                   = var.public_subnet_id
  vpc_security_group_ids      = [var.bastion_sg_id]
  key_name                    = var.key_name
  associate_public_ip_address = true

  root_block_device {
    volume_size = 10
    volume_type = "gp3"
    encrypted   = true
  }

  tags = {
    Name = "${var.project}-${var.environment}-bastion"
    Role = "bastion"
  }
}

resource "aws_instance" "web" {
  ami                         = var.ami_id
  instance_type               = "t3.small"
  subnet_id                   = var.public_subnet_id
  vpc_security_group_ids      = [var.web_sg_id]
  key_name                    = var.key_name
  associate_public_ip_address = true

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
    encrypted   = true
  }

  tags = {
    Name = "${var.project}-${var.environment}-web"
    Role = "web"
  }
}

resource "aws_instance" "app" {
  ami                         = var.ami_id
  instance_type               = "t3.small"
  subnet_id                   = var.private_subnet_id
  vpc_security_group_ids      = [var.app_sg_id]
  key_name                    = var.key_name
  associate_public_ip_address = false

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
    encrypted   = true
  }

  tags = {
    Name = "${var.project}-${var.environment}-app"
    Role = "app"
  }
}
