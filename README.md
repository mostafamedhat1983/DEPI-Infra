# AWS Infrastructure as Code (IaC) with Terraform

![Terraform Version](https://img.shields.io/badge/terraform-%3E%3D4.0-blue)
![AWS Provider](https://img.shields.io/badge/AWS-Provider-orange)
![infra-pic](https://github.com/user-attachments/assets/09db10ea-795c-4326-bdd7-d284bd1c68ca)

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
Navigate to ansible folder and run the following command
ansible-playbook -i inventory my_playbook.yml --ask-vault-pass

Jenkins, Docker, and AWS CLI Installation and Configuration Guide 🚀
This Ansible playbook is designed to automate the installation and configuration of Jenkins, Docker, kubectl, and AWS CLI on a server. It ensures that all necessary components are installed, configured, and verified for a seamless CI/CD pipeline setup. Below is a breakdown of the tasks included in this playbook:

📦 Jenkins Installation and Configuration
Install Java 17 (OpenJDK): Jenkins requires Java 17 or higher. This task installs OpenJDK 17.
Install Jenkins Dependencies: Installs essential packages required for Jenkins.
Add Jenkins Repository and GPG Key: Securely adds Jenkins' official repository and GPG key.
Install Jenkins: Installs the Jenkins package.
Start and Enable Jenkins Service: Ensures Jenkins starts on boot.
Retrieve Jenkins Initial Admin Password: Fetches the initial admin password for Jenkins setup.
🐳 Docker Installation
Install Docker Dependencies: Installs required packages for Docker.
Add Docker GPG Key and Repository: Adds Docker's official GPG key and repository.
Install Docker Packages: Installs Docker and its components.
Start and Enable Docker Service: Ensures Docker starts on boot.
☸️ kubectl Installation
Download and Install kubectl: Installs the Kubernetes CLI tool for managing Kubernetes clusters.
☁️ AWS CLI Installation
Install AWS CLI Dependencies: Installs necessary packages for AWS CLI.
Check and Install AWS CLI: Downloads and installs AWS CLI if not already installed.
Configure AWS CLI Credentials: Sets up AWS credentials for accessing AWS services.
🔄 EKS Kubeconfig Update
Update EKS Kubeconfig: Updates the kubeconfig file to access the EKS cluster.
👥 Add Jenkins to Docker Group
Add Jenkins to Docker Group: Grants Jenkins user permissions to run Docker commands.
✅ Verification of Installations
Verify Docker Installation: Checks Docker version and service status.
Verify kubectl Installation: Checks kubectl version.
Verify Jenkins Service: Ensures Jenkins service is running and retrieves the initial admin password if needed.
This playbook is a comprehensive solution for setting up a CI/CD environment with Jenkins, Docker, and AWS CLI, ensuring all components are correctly installed and configured.
## 🧹 Cleanup
### To destroy all resources:
```bash
terraform destroy
```
