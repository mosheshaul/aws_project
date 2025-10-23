terraform {
  required_version = ">= 1.6.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region  = var.region
  profile = var.aws_profile

  default_tags {
    tags = {
      Project = "terraform-builder"
      Owner   = "student"
    }
  }
}

# Ubuntu 22.04 LTS (Jammy) - latest HVM EBS AMI in us-east-1
# Canonical owner: 099720109477
data "aws_ami" "ubuntu_jammy" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Security Group - restrict to your IP on 22 and 5001, allow all egress
resource "aws_security_group" "builder_sg" {
  name        = "builder-sg"
  description = "SG for builder EC2"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH from student IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.my_ip}/32"]
  }

  ingress {
    description = "Python app port"
    from_port   = 5001
    to_port     = 5001
    protocol    = "tcp"
    cidr_blocks = ["${var.my_ip}/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Register your public key with AWS (the private key stays local)
resource "aws_key_pair" "builder_key" {
  key_name   = "builder-key"
  public_key = file("${path.module}/builder-key.pub")
}

resource "aws_instance" "builder" {
  ami                         = data.aws_ami.ubuntu_jammy.id
  instance_type               = var.instance_type
  subnet_id                   = var.public_subnet_id
  vpc_security_group_ids      = [aws_security_group.builder_sg.id]
  key_name                    = aws_key_pair.builder_key.key_name
  associate_public_ip_address = true

  tags = {
    Name = "builder"
  }
}
