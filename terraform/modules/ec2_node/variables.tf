variable "vtype" {
  type        = string
  description = "The virtualization type of the image"
  default     = "hvm"
}

variable "name" {
  type        = string
  description = "The human readable name of the EC2 AMI"
}

variable "owner" {
  type        = string
  description = "The owner ID of the AMI"
}

variable "instance" {
  type        = string
  description = "The size of the EC2 instance to proviesion"
}

variable "security_group_id" {
  type        = string
  description = "The ID of the security group the EC2 image should run under"
}

variable "key_pair_id" {
  type        = string
  description = "The ID of the key pair to use for SSH access"
}