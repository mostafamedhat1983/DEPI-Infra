output "endpoint" {
  value = aws_rds_cluster.this.endpoint
}

output "reader_endpoint" {
  value = aws_rds_cluster.this.reader_endpoint
}

output "db_sg_id" {
  value = aws_security_group.aurora.id
}