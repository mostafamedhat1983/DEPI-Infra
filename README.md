# AWS Infrastructure as Code (IaC) with Terraform

![Terraform Version](https://img.shields.io/badge/terraform-%3E%3D4.0-blue)
![AWS Provider](https://img.shields.io/badge/AWS-Provider-orange)

This Terraform project provisions a complete AWS infrastructure including:
- 🛡️ VPC with public and private subnets
- 🚀 EKS cluster with node groups
- 🗄️ Aurora MySQL database
- 🛠️ Jenkins EC2 instance with IAM permissions
- 🔒 Security groups and networking components

## 📋 Prerequisites

- AWS Account with IAM permissions
- Terraform v4.0+
- AWS CLI configured
- kubectl (for EKS interaction)
- Git

## 🚀 Quick Start

```bash
# Clone repository
git clone https://github.com/mostafamedhat1983/DEPI-Infra.git
cd your-repo

# Initialize Terraform
terraform init

# Review execution plan
terraform plan

# Deploy infrastructure
terraform apply
