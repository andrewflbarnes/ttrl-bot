variable "region" {
  type        = string
  description = "The region to provision the resources in"
}

variable "ec2_name" {
  type        = string
  description = "The human readable name of the EC2 AMI"
  default     = "bitnami-node-14.15.1-0-linux-debian-10-x86_64-hvm-ebs-nami"
}

variable "ec2_owner" {
  type        = string
  description = "The owner ID of the AMI"
  default     = "979382823631"
}

variable "ec2_instance" {
  type        = string
  description = "The size of the EC2 instance to proviesion"
  default     = "t2.micro"
}

variable "public_key" {
  type        = string
  description = "The public key corresponding to the key to be associated with access to the EC2 instance"
}