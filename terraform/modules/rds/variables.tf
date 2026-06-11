# terraform/modules/rds/variables.tf

variable "project_name" {
  description = "Project name prefix for resource naming"
  type        = string
}

variable "environment" {
  description = "Deployment environment (dev, staging, prod)"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC where RDS will be created. RDS lives in private subnets of this VPC."
  type        = string
  # Comes from: module.vpc.vpc_id
}

variable "private_subnet_ids" {
  description = "Private subnet IDs for the RDS subnet group. RDS requires at least 2 AZs for the subnet group."
  type        = list(string)
  # Comes from: module.vpc.private_subnet_ids
}

variable "eks_sg_id" {
  description = "Security group ID of EKS nodes. Only EKS pods will be allowed to connect to RDS on port 5432."
  type        = string
  # Comes from: module.eks.node_security_group_id
}

variable "db_name" {
  description = "Name of the initial database to create inside PostgreSQL."
  type        = string
  default     = "p9db"
}

variable "db_username" {
  description = "Master username for the PostgreSQL database."
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "Master password for the PostgreSQL database. Mark sensitive so Terraform never prints it."
  type        = string
  sensitive   = true
}

variable "instance_class" {
  description = "RDS instance type. db.t3.micro is enough for dev. Use db.r6g.large or higher in production."
  type        = string
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  description = "Disk size for the RDS instance in GB."
  type        = number
  default     = 20
}

variable "multi_az" {
  description = "Enable Multi-AZ deployment for high-availability. Always true in production."
  type        = bool
  default     = false   # Keep false in dev to save cost
}

variable "skip_final_snapshot" {
  description = "Skip final snapshot when destroying RDS. Set to false in production to preserve data."
  type        = bool
  default     = true    # true in dev so terraform destroy doesn't hang
}