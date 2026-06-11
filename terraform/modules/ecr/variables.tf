# terraform/modules/ecr/variables.tf

variable "project_name" {
  description = "Project name. Repository will be named: <project_name>-nodejs-app"
  type        = string
}

variable "environment" {
  description = "Deployment environment (dev, staging, prod). Included in resource tags."
  type        = string
}

variable "image_tag_mutability" {
  description = "Whether image tags can be overwritten. MUTABLE allows re-pushing latest. IMMUTABLE enforces unique tags."
  type        = string
  default     = "MUTABLE"

  validation {
    condition     = contains(["MUTABLE", "IMMUTABLE"], var.image_tag_mutability)
    error_message = "image_tag_mutability must be MUTABLE or IMMUTABLE."
  }
}

variable "scan_on_push" {
  description = "Automatically scan images for vulnerabilities when pushed to ECR."
  type        = bool
  default     = true
}

variable "max_image_count" {
  description = "Maximum number of images to keep in ECR. Older images are automatically deleted. Prevents storage cost bloat."
  type        = number
  default     = 10
}