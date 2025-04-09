terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = var.region
}

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
  }
}

module "vpc" {
  source       = "./modules/vpc"
  name         = "main-vpc"
  cidr         = "10.0.0.0/16"
  azs          = var.azs
  region       = var.region
  cluster_name = "python-app-cluster"
}

module "security_groups" {
  source                  = "./modules/security_group"
  name                    = "python-app"
  vpc_id                  = module.vpc.vpc_id
  cluster_security_group_id = module.eks.cluster_security_group_id
}

module "ssh_key" {
  source   = "./modules/key_pair"
  key_name = var.key_name
}

module "jenkins" {
  source          = "./modules/instances"
  instance_name   = "Jenkins"
  ami             = var.ami
  instance_type   = "t2.micro"
  subnet_id       = module.vpc.public_subnets[0]
  security_groups = [module.security_groups.ssh_sg_id, module.security_groups.infra_sg_id]
  key_name        = module.ssh_key.key_name
}

module "aurora" {
  source          = "./modules/aurora"
  vpc_id          = module.vpc.vpc_id
  subnets         = slice(module.vpc.private_subnets, 0, 2)
  db_name         = var.db_name
  username        = var.db_username
  password        = var.db_password
  allowed_cidr_blocks = [module.vpc.vpc_cidr_block]
}

module "eks" {
  source          = "./modules/eks"
  cluster_name    = "python-app-cluster"
  subnets         = concat(module.vpc.public_subnets, module.vpc.private_subnets)
  security_groups = [module.security_groups.web_sg_id]
  node_group_name = "python-app-nodes"
  node_type       = "t3.medium"
  region          = var.region
  key_name        = module.ssh_key.key_name
  min_size        = 1
  max_size        = 3
  desired_size    = 2
}

# Output to file --> Inventory file structure for Ansible
resource "local_file" "inventory" {
  content = <<-EOT
  [jenkins]
  ${module.jenkins.public_ip} ansible_user=ubuntu ansible_private_key_file=/var/lib/jenkins/jenkins-key.pem
  EOT
  filename = "${path.cwd}/../ansible/inventory"
  depends_on = [
    module.eks,
    module.jenkins,
    module.aurora
  ]
}

# Output to file --> EKS Data
resource "local_file" "eks_data" {
  content = <<-EOT
  Cluster Name: ${module.eks.cluster_name}
  Endpoint: ${module.eks.cluster_endpoint}
  Certificate: ${module.eks.cluster_certificate_authority}
  EOT
  filename = "${path.cwd}/EKS-Data"
  depends_on = [
    module.eks,
    module.jenkins,
    module.aurora
  ]
}

# Output to file --> Aurora_DB
resource "local_file" "aurora_data" {
  content  = "Endpoint: ${module.aurora.endpoint}"
  filename = "${path.cwd}/Aurora-Data"
  depends_on = [
    module.eks,
    module.jenkins,
    module.aurora
  ]
}