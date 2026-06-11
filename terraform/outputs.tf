output "jenkins_public_ip"    { value = module.ec2.jenkins_public_ip }
output "ecr_repository_url"   { value = module.ecr.repository_url }
output "eks_cluster_endpoint" { value = module.eks.cluster_endpoint }
output "eks_cluster_name"     { value = module.eks.cluster_name }
output "rds_endpoint"         { value = module.rds.endpoint }
output "app_s3_bucket"        { value = module.s3.app_bucket_name }
output "irsa_role_arn"        { value = module.iam.irsa_role_arn }