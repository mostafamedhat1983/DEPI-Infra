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
### 1. Clone repository
```bash
git clone https://github.com/mostafamedhat1983/DEPI-Infra.git
cd your-repo
```
### 2. Initialize Terraform
```bash
terraform init
```
### 3. Configure variables
Create/edit terraform.tfvars:
```bash
db_username = "admin"
db_password = "your_secure_password_here"
```
### 4. Deploy infrastructure
```bash
terraform plan
terraform apply
```
## 📂 Project Structure
```bash
.
├── modules/
│   ├── aurora/          # Database resources
│   ├── eks/             # Kubernetes cluster
│   ├── instances/       # EC2 configurations
│   ├── key_pair/        # SSH key management
│   ├── security_group/  # Network security
│   └── vpc/            # Networking
├── main.tf              # Root module
├── variables.tf         # Input variables
├── outputs.tf           # Output values
└── README.md           # This file
```
## ⚙️ Configuration
![image](https://github.com/user-attachments/assets/fba1b838-3085-4e9d-89af-ddf37287beb3)
## 🔌 Accessing Resources
### After deployment:
#### Connect to Jenkins
```bash
ssh -i ./modules/key_pair/jenkins-key.pem ubuntu@$(terraform output -raw jenkins_ip)
```
#### Configure kubectl
```bash
aws eks update-kubeconfig \
  --name $(terraform output -raw cluster_name) \
  --region $(terraform output -raw region)
```
#### Database Connection
```bash
echo "Aurora endpoint: $(terraform output -raw aurora_endpoint)"
```
## Ansible
ansible-playbook -i inventory my_playbook.yml --ask-vault-pass
## 🧹 Cleanup
### To destroy all resources:
```bash
terraform destroy
```
