output "instance_public_ip" {
  description = "Public IP of the builder EC2"
  value       = aws_instance.builder.public_ip
}

output "security_group_id" {
  description = "Security Group ID"
  value       = aws_security_group.builder_sg.id
}

output "private_key_path" {
  description = "Location of the local private key file (not stored in state)"
  value       = "${path.module}/builder-key"
}
