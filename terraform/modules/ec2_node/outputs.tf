output "public_dns" {
  description = "The public DNS of the created AWS instance"
  value       = aws_instance.ttrl_bot_instance.public_dns
}