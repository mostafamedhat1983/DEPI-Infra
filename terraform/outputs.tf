output "jenkins_ip" {
  value = module.jenkins.public_ip
}

output "ssh_key_file" {
  value = module.ssh_key.private_key_filename
}

output "cluster_name" {
  value = module.eks.cluster_name
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "cluster_certificate" {
  value = module.eks.cluster_certificate
}

output "region" {
  value = var.region
}

output "aurora_endpoint" {
  value = module.aurora.endpoint
}