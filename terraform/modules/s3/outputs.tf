output "app_bucket_name" { value = aws_s3_bucket.app.bucket }
output "app_bucket_arn" { value = aws_s3_bucket.app.arn }
output "app_bucket_domain_name" { value = aws_s3_bucket.app.bucket_regional_domain_name }
