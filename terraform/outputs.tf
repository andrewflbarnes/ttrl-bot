output "public_dns" {
  description = "The public DNS of the AWS instance the TTRL bot will run in"
  value       = module.ec2_node.public_dns
}