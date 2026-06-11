# terraform/modules/iam/variables.tf

variable "project_name" {
  description = "Project name prefix for IAM resource naming."
  type        = string
}

variable "environment" {
  description = "Deployment environment (dev, staging, prod)."
  type        = string
}

variable "oidc_provider" {
  description = <<-EOT
    OIDC provider URL without the https:// prefix.
    Used in the IAM trust policy condition to scope the role to a specific
    Kubernetes service account.
    Example: oidc.eks.us-east-1.amazonaws.com/id/EXAMPLED539D4633E53DE1B716D3041E
  EOT
  type        = string
  # Comes from: module.eks.oidc_provider
}

variable "oidc_provider_arn" {
  description = <<-EOT
    Full ARN of the OIDC provider created for the EKS cluster.
    This is set as the Federated principal in the trust policy.
    Example: arn:aws:iam::123456789012:oidc-provider/oidc.eks.us-east-1.amazonaws.com/id/...
  EOT
  type        = string
  # Comes from: module.eks.oidc_provider_arn
}

variable "s3_bucket_arn" {
  description = "ARN of the S3 bucket the app pods need to read/write. This is granted in the IRSA role policy."
  type        = string
  # Comes from: module.s3.app_bucket_arn
}

variable "ecr_arn" {
  description = "ARN of the ECR repository. Grants pods permission to pull images via IRSA."
  type        = string
  # Comes from: module.ecr.repository_arn
}

variable "k8s_namespace" {
  description = "Kubernetes namespace where the service account lives. Used in OIDC trust policy condition."
  type        = string
  default     = "default"
}

variable "k8s_service_account" {
  description = "Name of the Kubernetes service account that will assume this IAM role. Must match the serviceaccount name in the Helm chart."
  type        = string
  default     = "nodejs-app"
}