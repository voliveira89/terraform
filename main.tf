terraform {
  required_providers {
    tls = {
      source = "hashicorp/tls"
      version = "2.2.0"
    }
  }
}

provider "aws" {
    region = "eu-west-1"
}

resource "aws_instance" "aws_instance" {
    ami           = "ami-04137ed1a354f54c4"
    instance_type = "t3a.medium"
    vpc_security_group_ids = [aws_security_group.instance.id]
    key_name      = "${aws_key_pair.generated_key.key_name}"

    tags = {
        Name = "instance-tag"
        Terraform = true
    }
}

variable "port" {
    description = "HTTP"
    type = number
    default = 80
}

resource "aws_security_group" "instance" {
    name = "instance-sg"

    ingress {
        from_port = var.port
        to_port = var.port
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "tls_private_key" "instace_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

variable "key_name" {}

resource "aws_key_pair" "generated_key" {
  key_name   = "${var.key_name}"
  public_key = "${tls_private_key.instace_key.public_key_openssh}"
}