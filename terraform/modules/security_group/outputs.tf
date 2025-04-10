output "ssh_sg_id" {
  description = "ID of the SSH Security Group."
  value       = aws_security_group.ssh.id
}

output "web_sg_id" {
  description = "ID of the Web Security Group."
  value       = aws_security_group.web.id
}

output "infra_sg_id" {
  description = "ID of the Internal Infrastructure Security Group."
  value       = aws_security_group.infra_sg.id
}