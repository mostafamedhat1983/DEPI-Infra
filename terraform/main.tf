terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
    local = {
      source = "hashicorp/local"
      version = "~> 2.2"
    }
  }
}

provider "aws" {
  region = var.region
}

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
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
  source                    = "./modules/security_group"
  name                      = "python-app"
  vpc_id                    = module.vpc.vpc_id
}

module "ssh_key" {
  source   = "./modules/key_pair"
  key_name = var.key_name
}

resource "aws_iam_role" "jenkins_role" {
  name = "jenkins-instance-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    Name = "JenkinsInstanceRole"
  }
}

resource "aws_iam_policy" "jenkins_eks_aurora_policy" {
  name        = "jenkins-eks-aurora-access"
  description = "Policy granting Jenkins full access to EKS and Aurora (RDS)"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["eks:*"]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action   = ["rds:*"]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "jenkins_eks_aurora_attach" {
  role       = aws_iam_role.jenkins_role.name
  policy_arn = aws_iam_policy.jenkins_eks_aurora_policy.arn
}

resource "aws_iam_instance_profile" "jenkins_profile" {
  name = "jenkins-instance-profile"
  role = aws_iam_role.jenkins_role.name
}

module "jenkins" {
  source            = "./modules/instances"
  instance_name     = "Jenkins"
  ami               = var.ami
  instance_type     = "t3.medium"
  subnet_id         = module.vpc.public_subnets[0]
  security_groups   = [module.security_groups.ssh_sg_id, module.security_groups.infra_sg_id]
  key_name          = module.ssh_key.key_name
  iam_instance_profile = aws_iam_instance_profile.jenkins_profile.name

  depends_on = [aws_iam_instance_profile.jenkins_profile]
}

module "aurora" {
  source = "./modules/aurora"
  vpc_id = module.vpc.vpc_id
  subnets = slice(module.vpc.private_subnets, 0, 2)
  db_name = var.db_name
  username = var.db_username
  password = var.db_password
  allowed_security_group_id = module.security_groups.web_sg_id

  depends_on = [module.eks]
}

module "eks" {
  source           = "./modules/eks"
  cluster_name     = "python-app-cluster"
  subnets          = module.vpc.public_subnets
  vpc_id           = module.vpc.vpc_id
  security_groups  = [module.security_groups.web_sg_id]
  node_group_name  = "python-app-nodes"
  node_type        = "t3.medium"
  region           = var.region
  key_name         = module.ssh_key.key_name
  min_size         = 1
  max_size         = 3
  desired_size     = 1

  depends_on = [module.vpc, module.security_groups]
}

resource "aws_security_group_rule" "cluster_to_nodes" {
  description              = "Allow EKS Cluster Control Plane to Nodes (kubelet, etc.)"
  type                     = "ingress"
  from_port                = 1025
  to_port                  = 65535
  protocol                 = "tcp"
  security_group_id        = module.eks.cluster_security_group_id
  source_security_group_id = module.eks.cluster_security_group_id
  depends_on = [module.eks]
}

resource "aws_security_group_rule" "nodes_to_cluster" {
  description              = "Allow EKS Nodes to Cluster Control Plane API"
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = module.eks.cluster_security_group_id
  source_security_group_id = module.eks.cluster_security_group_id
  depends_on = [module.eks]
}

# Output to file --> Inventory file structure for Ansible
resource "local_file" "inventory" {
  content = <<-EOT
[jenkins_server]
${module.jenkins.public_ip} ansible_user=ubuntu ansible_ssh_private_key_file=../terraform/modules/key_pair/jenkins-key.pem
EOT
  filename = "${path.cwd}/../ansible/inventory"

  depends_on = [
    module.jenkins,
    module.eks,
    module.aurora,
    module.ssh_key
  ]
}

# Output to file --> EKS Data
resource "local_file" "eks_data" {
  content = <<-EOT
Cluster Name: ${module.eks.cluster_name}
Endpoint: ${module.eks.cluster_endpoint}
Certificate Authority Data (Base64): ${module.eks.cluster_certificate_authority_data}
# Kubeconfig command:
# aws eks update-kubeconfig --name ${module.eks.cluster_name} --region ${var.region}
EOT
  filename = "${path.cwd}/EKS-Data"

  depends_on = [
    module.jenkins,
    module.eks,
    module.aurora,
    module.ssh_key
  ]
}

# Output to file --> Aurora_DB
resource "local_file" "aurora_data" {
  content  = "Endpoint: ${module.aurora.endpoint}"
  filename = "${path.cwd}/Aurora-Data"

  depends_on = [
    module.jenkins,
    module.eks,
    module.aurora,
    module.ssh_key
  ]
}
