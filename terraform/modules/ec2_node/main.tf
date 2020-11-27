provider "aws" {
  alias = "region"
}

data "aws_ami" "ttrl_bot_ami" {
  provider = aws.region

  most_recent = true

  filter {
    name   = "name"
    values = [var.name]
  }

  filter {
    name   = "virtualization-type"
    values = [var.vtype]
  }

  owners = [var.owner]
}

resource "aws_instance" "ttrl_bot_instance" {
  provider = aws.region

  ami           = data.aws_ami.ttrl_bot_ami.id
  instance_type = var.instance

  vpc_security_group_ids = [var.security_group_id]
  key_name               = var.key_pair_id

  tags = {
    "Name" = "ttrl-bot"
  }
}