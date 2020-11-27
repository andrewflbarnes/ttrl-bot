output "security_group_id" {
  description = "The ID of the security group allowing outbound connections"
  value       = aws_security_group.instance.id
}