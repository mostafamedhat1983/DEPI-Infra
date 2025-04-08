# Ansible Playbook for Jenkins, Docker, and kubectl

## Prerequisites

### 1️⃣ Supported Ubuntu Versions
- **Ubuntu 22.04 LTS** (Recommended)
- **Ubuntu 20.04 LTS** (Supported)
- ❌ **Avoid Ubuntu 18.04 or older** (outdated packages)

### 2️⃣ Required System Packages
Before running the playbook, install the following dependencies:
```sh
sudo apt update && sudo apt install -y \
    curl wget apt-transport-https ca-certificates \
    gnupg software-properties-common
```

### 3️⃣ Install Ansible (On Control Node)
Ensure **Ansible 2.10+** is installed on the control machine:
```sh
sudo apt update
sudo apt install -y ansible
ansible --version
```

### 4️⃣ SSH Access to Target Machine
The Ansible control node must have **passwordless SSH access** to the target machine.
```sh
ssh-copy-id -i ~/.ssh/id_rsa.pub ubuntu@<TARGET-IP>
```
For AWS EC2 instances, use the `.pem` key file:
```sh
ssh -i AnsibleKey.pem ubuntu@<TARGET-IP>
```

### 5️⃣ Python Installation on Target Machine
Ensure **Python 3** is installed on the target machine:
```sh
python3 --version
```
If not installed:
```sh
sudo apt install -y python3 python3-apt
```

### 6️⃣ Sudo Privileges for Ansible User
Ensure the user running Ansible has **sudo** access:
```sh
sudo usermod -aG sudo ubuntu
```
Verify with:
```sh
sudo -l
```

### 7️⃣ Open Required Firewall Ports
Ensure required ports are open:
```sh
sudo ufw allow 22     # SSH
sudo ufw allow 8080   # Jenkins
sudo ufw allow 2376   # Docker (if needed)
sudo ufw allow 6443   # Kubernetes API Server (if needed)
sudo ufw enable
```

### 8️⃣ Java 17 for Jenkins
Modify the playbook to install **Java 17** instead of Java 11:
```yaml
    - name: Install Java (OpenJDK 17)
      apt:
        name: openjdk-17-jdk
        state: present
        update_cache: yes
```
Verify installation:
```sh
java -version
```
Expected output:
```
openjdk version "17.0.X" ...
```

### 9️⃣ Ansible Inventory File
Ensure your **inventory file** (`inventory.ini`) contains the correct target machine:
```ini
[jenkins_servers]
196.221.30.137 ansible_user=ubuntu ansible_ssh_private_key_file=AnsibleKey.pem
```

## Running the Playbook 🚀
After setting up everything, run the playbook with:
```sh
ansible-playbook -i inventory.ini my_playbook.yml
```

## Summary ✅
| Component       | Required Version / Configuration |
|----------------|--------------------------------|
| **Ubuntu Version** | 22.04 LTS (preferred) or 20.04 LTS |
| **Ansible Version** | 2.10+ |
| **Python** | 3.6+ (installed by default on Ubuntu 20.04+) |
| **Java for Jenkins** | OpenJDK 17 |
| **SSH Access** | Set up with correct key (`.pem` for AWS) |
| **User Privileges** | Must have sudo access |
| **Firewall Rules** | Open ports 22, 8080, 2376, 6443 |


## 📂 Project Structure
```
ansible-files/
│── ansible.cfg           # Ansible configuration file
│── hosts                 # Inventory file (target hosts)
│── my_inventory.ini      # Alternative inventory file
│── my_playbook.yml       # Ansible playbook
│── README.md             # This guide
```

## 🔧 Configuration
### 1️⃣ Edit the Inventory File (`hosts` or `my_inventory.ini`)
Add target hosts under the relevant groups:
```ini
[web_servers]
192.168.1.10
192.168.1.11

[db_servers]
192.168.1.20
```

Alternatively, if using an `.ini` file:
```ini
[web_servers]
server1 ansible_host=192.168.1.10 ansible_user=root
server2 ansible_host=192.168.1.11 ansible_user=root
```

### 2️⃣ Configure `ansible.cfg`
Ensure `ansible.cfg` points to the correct inventory file:
```ini
[defaults]
inventory = ./hosts  # Change if using a different inventory file
host_key_checking = False
```

## ▶️ Running the Playbook
Run the Ansible playbook with:
```bash
ansible-playbook -i hosts my_playbook.yml
```

For a specific group:
```bash
ansible-playbook -i hosts my_playbook.yml --limit web_servers
```

For debugging (verbose mode):
```bash
ansible-playbook -i hosts my_playbook.yml -vvv
```

## 🔍 Verify Connection to Hosts
Before running the playbook, test the connection:
```bash
ansible -i hosts all -m ping
```

If successful, you’ll see output like:
```bash
192.168.1.10 | SUCCESS => {
    "ping": "pong"
}
```

## 🛠 Troubleshooting
- **Permission denied?** Use `--ask-become-pass` for sudo access:
  ```bash
  ansible-playbook -i hosts my_playbook.yml --ask-become-pass
  ```

- **Authentication failure?** Ensure SSH keys or correct passwords are set.

