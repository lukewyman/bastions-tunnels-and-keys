data "aws_ami" "ubuntu" {
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  most_recent = true
  owners      = ["099720109477"]
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "template_cloudinit_config" "config" {
  gzip          = false
  base64_encode = true

  part {
    content_type = "text/x-shellscript"
    content      = <<-EOT
    #!/bin/bash

    sudo apt-get update -y
    sudo apt-get install -y postgresql-client

    EOT
  }
}

data "terraform_remote_state" "vpc" {
  backend = "remote"

  config = {
    hostname     = "app.terraform.io"
    organization = "spikes"

    workspaces = {
      name = "bastions-tunnels-and-keys-vpc"
    }
  }
}

