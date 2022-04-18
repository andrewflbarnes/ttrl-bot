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

module "api_gateway" {
  source = "./modules/api_gateway"

  providers = {
    aws.region = aws.region
  }
}
