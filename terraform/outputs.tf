output "jenkins_ip" {
  description = "Public IP address of the Jenkins instance."
  value       = module.jenkins.public_ip
}

output "ssh_key_filename" {
  description = "Path to the private key file created for SSH access. Stored locally where Terraform was run."
  value       = module.ssh_key.private_key_filename
}

output "cluster_name" {
  description = "Name of the EKS cluster."
  value       = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "Endpoint for the EKS cluster API server."
  value       = module.eks.cluster_endpoint
}

output "cluster_certificate_authority_data" {
  description = "Base64 encoded certificate data required to communicate with the cluster."
  value       = module.eks.cluster_certificate_authority_data
}

output "region" {
  description = "AWS region where the infrastructure is deployed."
  value       = var.region
}

output "aurora_endpoint" {
  description = "Connection endpoint for the Aurora cluster writer instance."
  value       = module.aurora.endpoint
}

output "configure_kubectl" {
  description = "Command to configure kubectl for the EKS cluster."
  value       = "aws eks update-kubeconfig --name ${module.eks.cluster_name} --region ${var.region}"
}

output "eks_cluster_security_group_id" {
  description = "The security group ID created by EKS for the cluster."
  value       = module.eks.cluster_security_group_id
}

output "jenkins_instance_profile_name" {
  description = "Name of the IAM Instance Profile attached to the Jenkins instance."
  value       = aws_iam_instance_profile.jenkins_profile.name
}