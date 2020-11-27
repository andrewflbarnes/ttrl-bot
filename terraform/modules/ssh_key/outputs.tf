output "keypair_id" {
  description = "The ID of the generated keypair"
  value       = aws_key_pair.keypair.id
}