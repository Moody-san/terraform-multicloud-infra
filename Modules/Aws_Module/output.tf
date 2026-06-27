output "server_public_ip" {
  description = "Public Elastic IP attached to the AWS EC2 instance."
  value       = aws_eip.one.public_ip
}
