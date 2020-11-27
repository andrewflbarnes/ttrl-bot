provider "aws" {
  alias = "region"
}

resource "aws_key_pair" "keypair" {
  provider   = aws.region
  key_name   = "ttrl_bot_key"
  public_key = var.public_key
}