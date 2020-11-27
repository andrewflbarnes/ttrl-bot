provider "aws" {
  alias   = "region"
  profile = "default"
  region  = var.region
}

terraform {
  backend "s3" {
    bucket = "aflb-terraform-state"
    key    = "ttrl-bot/terraform.tfstate"
    region = "eu-west-2"
  }
}

module "ssh_key" {
  source = "./modules/ssh_key"

  providers = {
    aws.region = aws.region
  }

  public_key = var.public_key
}

module "security_group" {
  source = "./modules/security_group"

  providers = {
    aws.region = aws.region
  }
}

module "ec2_node" {
  source = "./modules/ec2_node"

  providers = {
    aws.region = aws.region
  }

  name              = var.ec2_name
  owner             = var.ec2_owner
  instance          = var.ec2_instance
  security_group_id = module.security_group.security_group_id
  key_pair_id       = module.ssh_key.keypair_id
}