# terraform/modules/ec2/variables.tf

variable "project_name" {
  description = "Project name prefix for resource naming"
  type        = string
}

variable "environment" {
  description = "Deployment environment (dev, staging, prod)"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC where Jenkins EC2 will be launched"
  type        = string
  # Comes from: module.vpc.vpc_id
}

variable "public_subnet_id" {
  description = "ID of the public subnet to launch Jenkins into. Jenkins must be publicly accessible (port 8080)."
  type        = string
  # Comes from: module.vpc.public_subnet_ids[0]
}

variable "instance_type" {
  description = "EC2 instance type for the Jenkins server. t3.medium = 2 vCPU, 4GB RAM — minimum for Jenkins + Docker."
  type        = string
  default     = "t3.medium"
}

variable "key_name" {
  description = "Name of the EC2 key pair for SSH access to Jenkins. Must already exist in AWS."
  type        = string
  # Example: "p9-key"
}

variable "ecr_repository_url" {
  description = "URL of the ECR repository Jenkins will push images to. Used in user_data.sh and IAM policy."
  type        = string
  # Comes from: module.ecr.repository_url
  # Example: "123456789012.dkr.ecr.us-east-1.amazonaws.com/p9-devops-nodejs-app"
}

variable "allowed_cidr_blocks" {
  description = "CIDR blocks allowed to reach Jenkins on port 8080 and 22. Defaults to 0.0.0.0/0 (open). Restrict to your office/VPN IP in production."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "root_volume_size" {
  description = "Size of the Jenkins EC2 root EBS volume in GB. Jenkins build workspaces and Docker images consume space quickly."
  type        = number
  default     = 30
}