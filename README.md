# AWS DevOps Pipeline

A comprehensive, production-ready AWS DevOps infrastructure automation project featuring a Node.js application deployed on EKS with complete CI/CD, monitoring, and infrastructure-as-code setup.

## 📋 Table of Contents

- [Overview](#overview)
- [Architecture](#architecture)
- [Technology Stack](#technology-stack)
- [Prerequisites](#prerequisites)
- [Project Structure](#project-structure)
- [Getting Started](#getting-started)
- [Infrastructure Setup](#infrastructure-setup)
- [Application Deployment](#application-deployment)
- [Monitoring & Observability](#monitoring--observability)
- [CI/CD Pipeline](#cicd-pipeline)
- [Configuration Management](#configuration-management)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)
- [License](#license)

## 🎯 Overview

This project demonstrates a complete DevOps workflow for deploying a containerized Node.js application on AWS infrastructure using modern automation tools. It includes:

- **Infrastructure as Code (IaC)**: Terraform modules for AWS resources
- **Container Registry**: Amazon ECR for Docker image management
- **Kubernetes Orchestration**: EKS cluster with Helm deployments
- **Configuration Management**: Ansible playbooks for system configuration
- **CI/CD Pipeline**: Jenkins with automated build and deployment stages
- **Monitoring & Logging**: Prometheus and Grafana integration
- **Database**: Amazon RDS PostgreSQL for application data

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────┐
│            AWS Account & VPC                        │
├─────────────────────────────────────────────────────┤
│                                                      │
│  ┌──────────────────┐      ┌──────────────────┐    │
│  │   EKS Cluster    │      │   RDS Database   │    │
│  │  (Kubernetes)    │      │  (PostgreSQL)    │    │
│  │                  │      │                  │    │
│  │  ┌────────────┐  │      └──────────────────┘    │
│  │  │  Pods &    │  │                              │
│  │  │  Services  │  │      ┌──────────────────┐    │
│  │  └────────────┘  │      │   Monitoring     │    │
│  │                  │      │  (Prometheus &   │    │
│  └──────────────────┘      │   Grafana)       │    │
│           │                 └──────────────────┘    │
│           ▼                                         │
│  ┌──────────────────┐                              │
│  │   ECR Registry   │                              │
│  │ (Docker Images)  │                              │
│  └──────────────────┘                              │
│                                                      │
│  ┌──────────────────────────────────────────────┐  │
│  │  Jenkins Pipeline (CI/CD)                    │  │
│  │  - Build, Test, Push, Deploy                 │  │
│  └──────────────────────────────────────────────┘  │
│                                                      │
│  ┌──────────────────┐      ┌──────────────────┐    │
│  │   S3 Buckets     │      │  IAM Roles &     │    │
│  │ (State, Config)  │      │  Policies        │    │
│  └──────────────────┘      └──────────────────┘    │
│                                                      │
└─────────────────────────────────────────────────────┘
```

## 🛠️ Technology Stack

### Core Infrastructure
- **AWS**: EKS, RDS, ECR, VPC, EC2, S3, IAM
- **Terraform**: v1.5.0+ (Infrastructure as Code)
- **Kubernetes**: 1.27+ (Container orchestration)
- **Docker**: Container runtime

### Application & Runtime
- **Node.js**: 18+ (Application runtime)
- **Express.js**: Web framework
- **PostgreSQL**: Relational database
- **Prom-client**: Prometheus metrics library

### Configuration & Deployment
- **Ansible**: System configuration & automation
- **Helm**: Kubernetes package management
- **Jenkins**: CI/CD automation

### Monitoring & Observability
- **Prometheus**: Metrics collection
- **Grafana**: Visualization & dashboarding

## 📦 Prerequisites

### Local Development Requirements
- AWS CLI v2.x
- Terraform >= 1.5.0
- kubectl >= 1.27
- Helm >= 3.12
- Docker Desktop or Docker Engine
- Node.js >= 18
- Ansible >= 2.10
- Git
- Bash 4+

### AWS Account Requirements
- AWS account with appropriate IAM permissions
- Region configured (default: us-east-1)
- No existing VPC or resources with conflicting names
- CloudFormation access enabled
- Service quotas for EKS and RDS

### Recommended AWS Permissions
```
- EC2 (full or limited to VPC, security groups, instances)
- EKS (cluster, node group management)
- RDS (database creation and management)
- ECR (repository and image management)
- IAM (role and policy creation)
- S3 (bucket and object management)
- CloudFormation (stack management)
- VPC (networking resources)
```

## 📁 Project Structure

```
aws-devops-pipeline/
├── app/                          # Node.js application
│   ├── src/
│   │   ├── index.js             # Application entry point
│   │   ├── routes/              # API routes
│   │   │   ├── api.js          # API endpoints
│   │   │   └── health.js       # Health check endpoint
│   │   └── middleware/          # Express middleware
│   │       └── metrics.js      # Prometheus metrics
│   ├── test/
│   │   └── app.test.js         # Application tests
│   ├── Dockerfile              # Docker image definition
│   ├── .dockerignore           # Files to exclude from Docker image
│   └── package.json            # Dependencies and scripts
│
├── terraform/                    # Infrastructure as Code
│   ├── main.tf                 # Main configuration
│   ├── variables.tf            # Variable definitions
│   ├── outputs.tf              # Output definitions
│   ├── terraform.tfvars.example # Example variables
│   ├── .terraform/             # Terraform working directory (generated)
│   │   └── providers/          # Downloaded providers
│   └── modules/                # Terraform modules
│       ├── vpc/                # VPC networking
│       ├── eks/                # EKS cluster
│       ├── rds/                # RDS database
│       ├── ecr/                # ECR registry
│       ├── ec2/                # EC2 instances
│       ├── iam/                # IAM roles and policies
│       └── s3/                 # S3 buckets
│
├── ansible/                     # Configuration management
│   ├── ansible.cfg             # Ansible configuration
│   ├── inventory/              # Inventory files
│   │   ├── hosts.ini          # Static inventory
│   │   └── aws_ec2.yml        # Dynamic AWS inventory
│   ├── group_vars/             # Group variables
│   │   ├── all.yml            # Common variables
│   │   └── ec2_workers.yml    # EC2-specific variables
│   ├── playbooks/              # Playbooks
│   │   ├── site.yml           # Main playbook
│   │   ├── configure.yml      # Configuration playbook
│   │   └── deploy.yml         # Deployment playbook
│   └── roles/                  # Ansible roles
│       ├── common/             # Common packages and tools
│       ├── docker/             # Docker installation
│       └── app/                # Application deployment
│
├── helm/                        # Kubernetes Helm charts
│   ├── nodejs-app/             # Application Helm chart
│   │   ├── Chart.yaml         # Chart metadata
│   │   ├── values.yaml        # Default values
│   │   ├── values-prod.yaml   # Production values
│   │   └── templates/         # Kubernetes templates
│   │       ├── deployment.yaml
│   │       ├── service.yaml
│   │       ├── configmap.yaml
│   │       ├── hpa.yaml       # Horizontal Pod Autoscaler
│   │       ├── ingress.yaml
│   │       └── servicemonitor.yaml # Prometheus scraping
│   └── templates/              # Base templates
│
├── jenkins/                     # CI/CD Pipeline
│   ├── Jenkinsfile            # Pipeline definition
│   └── scripts/                # Helper scripts
│       ├── health-check.sh    # Health check script
│       └── notify-slack.sh    # Slack notifications
│
├── monitoring/                  # Monitoring stack
│   ├── prometheus/             # Prometheus config
│   │   └── values.yaml        # Helm values
│   └── grafana/                # Grafana dashboards
│       └── dashboards/
│           └── nodejs-app.json # Application dashboard
│
├── scripts/                     # Deployment scripts
│   ├── bootstrap.sh           # Initialize Terraform state
│   ├── deploy.sh              # Deploy infrastructure
│   └── destroy.sh             # Destroy infrastructure
│
├── .gitignore                  # Git ignore rules
├── .git/                       # Git repository (generated)
└── README.md                   # This file
```

## 🚀 Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/sumanth-koppula/aws-devops-pipeline
cd aws-devops-pipeline
```

### 2. Configure AWS Credentials

```bash
aws configure
# Enter your AWS Access Key ID and Secret Access Key
# Default region: us-east-1
# Default output format: json
```

Alternatively, set environment variables:

```bash
export AWS_ACCESS_KEY_ID="your-access-key"
export AWS_SECRET_ACCESS_KEY="your-secret-key"
export AWS_DEFAULT_REGION="us-east-1"
```

### 3. Create Terraform Variables File

```bash
cd terraform
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your desired values
vim terraform.tfvars
```

Required variables:
- `aws_region`: AWS region (default: us-east-1)
- `project_name`: Project name for tagging
- `environment`: Environment name (dev, staging, prod)
- `cluster_name`: EKS cluster name
- `db_username`: RDS master username
- `db_password`: RDS master password (min 8 chars, alphanumeric)

### 4. Bootstrap Terraform State

```bash
# From the project root
./scripts/bootstrap.sh

# This creates:
# - S3 bucket for Terraform state
# - DynamoDB table for state locking
```

Expected output:
```
==> Creating Terraform state bucket: aws-devops-pipeline-terraform-state-XXXXXXXXXX
==> Creating DynamoDB lock table: aws-devops-pipeline-terraform-lock
```

### 5. Initialize Terraform

```bash
cd terraform
terraform init
# This downloads providers and initializes the working directory
```

### 6. Review and Apply Infrastructure

```bash
# Review planned changes
terraform plan -out=plan.tfplan

# Apply the plan (this may take 15-20 minutes)
terraform apply plan.tfplan
```

Expected resources created:
- VPC with public/private subnets
- EKS cluster (1.27+) with managed node groups
- RDS PostgreSQL database
- ECR repository
- Security groups and IAM roles
- S3 buckets for state and configuration

## 🐳 Application Deployment

### 1. Build and Push Docker Image

```bash
cd app
docker build -t nodejs-app:latest .

# Tag for ECR
ECR_URI=$(terraform output -raw ecr_repository_uri)
docker tag nodejs-app:latest ${ECR_URI}:latest

# Login to ECR
aws ecr get-login-password --region us-east-1 | \
  docker login --username AWS --password-stdin ${ECR_URI}

# Push image
docker push ${ECR_URI}:latest
```

### 2. Deploy with Helm

```bash
cd ../helm

# Install or upgrade the release
helm upgrade --install nodejs-app ./nodejs-app \
  -f nodejs-app/values.yaml \
  --namespace default \
  --create-namespace

# Verify deployment
kubectl get deployments
kubectl get pods
kubectl get svc
```

### 3. Verify Application

```bash
# Get LoadBalancer endpoint
kubectl get svc nodejs-app -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'

# Test health endpoint
curl http://<LOAD_BALANCER_ENDPOINT>/health

# Test API
curl http://<LOAD_BALANCER_ENDPOINT>/api/data
```

## 📊 Monitoring & Observability

### 1. Deploy Prometheus and Grafana

```bash
# Install Prometheus Operator
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

helm install prometheus prometheus-community/kube-prometheus-stack \
  -f monitoring/prometheus/values.yaml

# Verify installation
kubectl get pods -l app.kubernetes.io/name=prometheus
```

### 2. Access Grafana

```bash
# Port-forward to Grafana
kubectl port-forward svc/prometheus-grafana 3000:80

# Access at http://localhost:3000
# Default credentials: admin / prom-operator
```

### 3. View Application Metrics

- Dashboards are automatically created from ServiceMonitor
- Access the "Node.js App" dashboard
- Monitor metrics:
  - Request rate (requests/sec)
  - Response time (latency)
  - Error rate
  - CPU and memory usage

## 🔄 CI/CD Pipeline

### 1. Jenkins Setup

The `jenkins/Jenkinsfile` defines a complete CI/CD pipeline with stages:

```
1. Checkout        → Clone repository
2. Build           → Compile and test
3. Test            → Run test suite
4. Build Image     → Create Docker image
5. Push to ECR     → Push to container registry
6. Deploy to EKS   → Deploy using Helm
7. Verify          → Health checks
8. Notify          → Slack notification
```

### 2. Trigger Deployment

```bash
# Manual trigger (if Jenkins is setup)
curl -X POST http://jenkins-server/job/DevOps-Pipeline/build \
  --user admin:token

# Or commit to main branch (if webhook configured)
git commit -am "Deploy new version"
git push origin main
```

### 3. Monitor Pipeline

```bash
# View logs
kubectl logs -f deployment/jenkins

# Check build artifacts
# Jenkins UI: http://jenkins-server:8080
```

## ⚙️ Configuration Management

### 1. Configure EC2 Instances with Ansible

```bash
cd ansible

# Update inventory with actual EC2 instances
vim inventory/hosts.ini

# Or use dynamic inventory
export ANSIBLE_INVENTORY=inventory/aws_ec2.yml

# Run playbooks
ansible-playbook playbooks/site.yml -i inventory/hosts.ini

# Run specific role
ansible-playbook playbooks/configure.yml -i inventory/hosts.ini --tags=docker
```

### 2. Available Playbooks

- `site.yml`: Complete site configuration
- `configure.yml`: System and Docker configuration
- `deploy.yml`: Application deployment

### 3. Available Roles

- **common**: System packages, git, curl, wget
- **docker**: Docker installation and configuration
- **app**: Application setup and containerization

## 🔧 Troubleshooting

### Terraform Issues

#### State Lock Issues
```bash
# If state is locked
terraform force-unlock <LOCK_ID>

# Or manually remove from DynamoDB (AWS Console)
```

#### Provider Errors
```bash
# Validate configuration
terraform validate

# Format HCL files
terraform fmt -recursive

# Detailed debug output
TF_LOG=DEBUG terraform apply
```

### EKS/Kubernetes Issues

#### Cannot Connect to Cluster
```bash
# Update kubeconfig
aws eks update-kubeconfig --name <cluster-name> --region us-east-1

# Verify connection
kubectl cluster-info
kubectl get nodes
```

#### Pods Not Starting
```bash
# Check pod status
kubectl describe pod <pod-name>

# View logs
kubectl logs <pod-name>

# Check resource requests/limits
kubectl top pods
```

#### LoadBalancer Pending
```bash
# Check service status
kubectl describe svc nodejs-app

# May take 2-3 minutes for AWS to provision LoadBalancer
# Check AWS console > EC2 > Load Balancers
```

### RDS Connection Issues

```bash
# Test connection from pod
kubectl exec -it <pod-name> -- psql -h <rds-endpoint> -U <username> -d postgres

# Check security groups
aws ec2 describe-security-groups --query 'SecurityGroups[?GroupName==`*rds*`]'

# Check RDS status
aws rds describe-db-instances --db-instance-identifier <db-name>
```

### Application Issues

#### Container Won't Start
```bash
# Check image exists
aws ecr describe-images --repository-name nodejs-app

# Test image locally
docker run -it <image-uri> /bin/bash

# Check Dockerfile
docker build --no-cache -t test:latest .
```

#### Application Logs
```bash
# Stream logs from pod
kubectl logs -f deployment/nodejs-app

# Stream all container logs
kubectl logs -f deployment/nodejs-app --all-containers=true
```

## 🧹 Cleanup

### Destroy All Resources

```bash
# From terraform directory
cd terraform

# Show what will be destroyed
terraform destroy -auto-approve

# Or selective destroy
terraform destroy -target=module.eks -auto-approve
```

**Warning**: This will delete:
- EKS cluster and node groups
- RDS database
- VPC and networking resources
- IAM roles and policies
- ECR repository

### Destroy Terraform State

```bash
# Delete state files from S3
aws s3 rm s3://aws-devops-pipeline-terraform-state-XXXXXXXXXX --recursive

# Delete S3 bucket
aws s3api delete-bucket --bucket aws-devops-pipeline-terraform-state-XXXXXXXXXX --region us-east-1

# Delete DynamoDB table
aws dynamodb delete-table --table-name aws-devops-pipeline-terraform-lock --region us-east-1
```

## 📝 Contributing

### Development Workflow

1. Create a feature branch: `git checkout -b feature/your-feature`
2. Make changes and test locally
3. Commit with descriptive messages: `git commit -am "Add feature description"`
4. Push to branch: `git push origin feature/your-feature`
5. Submit a pull request

### Code Guidelines

- Follow Terraform/HCL formatting: `terraform fmt`
- Test Ansible playbooks before committing
- Keep Docker images minimal
- Document custom scripts
- Update this README for major changes

### Testing

```bash
# Terraform validation
cd terraform
terraform fmt -check -recursive
terraform validate

# Ansible syntax check
cd ../ansible
ansible-playbook playbooks/site.yml --syntax-check

# Application tests
cd ../app
npm test
npm run test -- --coverage
```

## 📚 Additional Resources

### AWS Documentation
- [EKS User Guide](https://docs.aws.amazon.com/eks/)
- [RDS PostgreSQL](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_PostgreSQL.html)
- [ECR Documentation](https://docs.aws.amazon.com/AmazonECR/)

### Terraform Documentation
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest)
- [Terraform Kubernetes Provider](https://registry.terraform.io/providers/hashicorp/kubernetes/latest)
- [Terraform Helm Provider](https://registry.terraform.io/providers/hashicorp/helm/latest)

### Kubernetes & Helm
- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [Helm Documentation](https://helm.sh/docs/)
- [Helm Chart Best Practices](https://helm.sh/docs/chart_best_practices/)

### Monitoring
- [Prometheus Documentation](https://prometheus.io/docs/)
- [Grafana Documentation](https://grafana.com/docs/grafana/latest/)


