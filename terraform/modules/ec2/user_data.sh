#!/bin/bash
set -euo pipefail

# Update system
yum update -y

# Install Java 17 (required for Jenkins)
amazon-linux-extras enable corretto17
yum install -y java-17-amazon-corretto-devel

# Install Jenkins
wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
yum install -y jenkins
systemctl enable jenkins
systemctl start jenkins

# Install Docker
yum install -y docker
systemctl enable docker
systemctl start docker
usermod -aG docker jenkins
usermod -aG docker ec2-user

# Install Docker Compose
curl -SL "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" \
  -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Install AWS CLI v2
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o /tmp/awscliv2.zip
unzip /tmp/awscliv2.zip -d /tmp
/tmp/aws/install

# Install kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Install Helm
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# Install Trivy
rpm -ivh "https://github.com/aquasecurity/trivy/releases/latest/download/trivy_$(curl -s https://api.github.com/repos/aquasecurity/trivy/releases/latest | grep tag_name | cut -d '"' -f4 | sed 's/v//')_Linux-64bit.rpm"

# Install Ansible
pip3 install ansible boto3 botocore

# Configure kubeconfig for EKS (fills in after Terraform provisions EKS)
# Jenkins pipeline calls: aws eks update-kubeconfig --name <cluster>

echo "Jenkins bootstrap complete — $(date)" >> /var/log/jenkins-bootstrap.log