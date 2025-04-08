output "jenkins_ip" {
  value = module.jenkins.public_ip
}

output "aurora_endpoint" {
  value = module.aurora.endpoint
}

output "cluster_name" {
  value = module.eks.cluster_name
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "ssh_key_file" {
  value = module.ssh_key.private_key_filename
}

output "region" {
  value = var.region
}