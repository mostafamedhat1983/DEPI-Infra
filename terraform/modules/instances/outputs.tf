output "public_ip" {
  description = "Public IP address of the instance (if assigned)."
  value       = aws_instance.main.public_ip
}

output "private_ip" {
  description = "Private IP address of the instance."
  value       = aws_instance.main.private_ip
}

output "instance_id" {
  description = "ID of the EC2 instance."
  value       = aws_instance.main.id
}

output "arn" {
  description = "ARN of the EC2 instance."
  value       = aws_instance.main.arn
}