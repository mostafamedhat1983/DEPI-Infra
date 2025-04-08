output "ssh_sg_id" {
  value = aws_security_group.ssh.id
}

output "web_sg_id" {
  value = aws_security_group.web.id
}

output "db_sg_id" {
  value = aws_security_group.db.id
}

output "infra_sg_id" {
  value = aws_security_group.infra_sg.id
}

output "nodes_sg_id" {
  value = aws_security_group.nodes.id
}