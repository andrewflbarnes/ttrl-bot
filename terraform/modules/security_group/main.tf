provider "aws" {
  alias = "region"
}

resource "aws_security_group" "instance" {
  provider = aws.region

  name        = "ttrl_allow_outbound"
  description = "Allow outbound connections (to Discord)"
  #   vpc_id      = aws_vpc.main.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" = "ttrl_allow_outbound"
  }
}