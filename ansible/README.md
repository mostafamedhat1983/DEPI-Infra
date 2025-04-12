Jenkins, Docker, and AWS CLI Installation and Configuration Guide using Ansible 🚀
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
