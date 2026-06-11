# terraform/modules/eks/variables.tf

variable "project_name" {
  description = "Project name prefix for resource naming"
  type        = string
}

variable "environment" {
  description = "Deployment environment (dev, staging, prod)"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC where the EKS cluster will be created"
  type        = string
  # Comes from: module.vpc.vpc_id
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for EKS worker nodes. Nodes run in private subnets — no direct internet exposure."
  type        = list(string)
  # Comes from: module.vpc.private_subnet_ids
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs. Required for EKS control plane and load balancers."
  type        = list(string)
  # Comes from: module.vpc.public_subnet_ids
}

variable "cluster_version" {
  description = "Kubernetes version for the EKS cluster (e.g. 1.28). Check AWS docs for supported versions."
  type        = string
  default     = "1.31"
}

variable "node_instance_types" {
  description = "EC2 instance types for the EKS managed node group. t3.large = 2 vCPU, 8GB RAM — good for running 4–6 pods."
  type        = list(string)
  default     = ["t3.large"]
}

variable "desired_capacity" {
  description = "Desired number of worker nodes in the EKS node group at any given time."
  type        = number
  default     = 2
}

variable "min_size" {
  description = "Minimum number of worker nodes. EKS will not scale below this."
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Maximum number of worker nodes. HPA can trigger scaling up to this limit."
  type        = number
  default     = 4
}

variable "enable_cluster_logging" {
  description = "Whether to enable EKS control plane logging to CloudWatch."
  type        = bool
  default     = true
}
