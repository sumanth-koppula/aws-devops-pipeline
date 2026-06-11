# terraform/modules/s3/variables.tf

variable "project_name" {
  description = "Project name prefix. Combined with environment and random suffix to create unique bucket names."
  type        = string
}

variable "environment" {
  description = "Deployment environment (dev, staging, prod). Included in bucket name."
  type        = string
}

variable "aws_region" {
  description = "AWS region where S3 buckets are created. Needed for bucket creation in non-us-east-1 regions."
  type        = string
  default     = "us-east-1"
}

variable "enable_versioning" {
  description = "Enable versioning on all buckets. Allows recovering deleted/overwritten objects."
  type        = bool
  default     = true
}

variable "force_destroy" {
  description = "Allow Terraform to delete non-empty buckets (destroys all objects inside). Set to false in production."
  type        = bool
  default     = true   # true in dev so terraform destroy works cleanly
}