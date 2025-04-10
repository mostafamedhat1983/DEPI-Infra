output "endpoint" {
  description = "The connection endpoint for the primary instance of the Aurora cluster."
  value       = aws_rds_cluster.this.endpoint
}

output "reader_endpoint" {
  description = "The connection endpoint for reader instances of the Aurora cluster."
  value       = aws_rds_cluster.this.reader_endpoint
}

output "db_sg_id" {
  description = "The ID of the security group for the Aurora cluster."
  value       = aws_security_group.aurora.id
}

output "cluster_arn" {
  description = "ARN of the Aurora cluster"
  value       = aws_rds_cluster.this.arn
}

output "cluster_resource_id" {
  description = "The Cluster Resource ID"
  value       = aws_rds_cluster.this.cluster_resource_id
}