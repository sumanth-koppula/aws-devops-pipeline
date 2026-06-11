variable "aws_region"   { default = "us-east-1" }
variable "project_name" { default = "p9-devops" }
variable "environment"  { default = "dev" }

variable "vpc_cidr"             { default = "10.0.0.0/16" }
variable "availability_zones"   { default = ["us-east-1a", "us-east-1b"] }
variable "public_subnet_cidrs"  { default = ["10.0.1.0/24", "10.0.2.0/24"] }
variable "private_subnet_cidrs" { default = ["10.0.3.0/24", "10.0.4.0/24"] }

variable "jenkins_instance_type" { default = "t3.medium" }
variable "key_name"              { description = "EC2 key pair name" }

variable "eks_cluster_version" { default = "1.28" }
variable "node_instance_types" { default = ["t3.large"] }
variable "desired_capacity"    { default = 2 }
variable "min_size"            { default = 1 }
variable "max_size"            { default = 4 }

variable "rds_instance_class" { default = "db.t3.micro" }
variable "db_name"            { default = "p9db" }
variable "db_username"        { default = "admin" }
variable "db_password"        { sensitive = true }