output "cluster_name" {
  description = "The name of the EKS cluster."
  value       = aws_eks_cluster.this.name
}

output "cluster_endpoint" {
  description = "The endpoint for the EKS cluster's API server."
  value       = aws_eks_cluster.this.endpoint
}

output "cluster_certificate_authority_data" {
  description = "Base64 encoded certificate data required to communicate with the cluster."
  value = aws_eks_cluster.this.certificate_authority[0].data
}

output "cluster_security_group_id" {
  description = "The security group ID associated with the EKS cluster control plane."
  value = aws_eks_cluster.this.vpc_config[0].cluster_security_group_id
}

output "node_group_role_arn" {
  description = "ARN of the IAM role associated with the EKS node group."
  value       = aws_iam_role.nodes.arn
}

output "cluster_arn" {
  description = "ARN of the EKS Cluster"
  value       = aws_eks_cluster.this.arn
}

output "node_group_name" {
  description = "Name of the EKS node group."
  value       = aws_eks_node_group.this.node_group_name
}

output "node_group_status" {
  description = "Status of the EKS node group."
  value       = aws_eks_node_group.this.status
}