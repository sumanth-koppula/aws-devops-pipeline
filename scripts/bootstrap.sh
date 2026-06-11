#!/bin/bash
# ── bootstrap.sh — Run ONCE before terraform init ─────────────────────
# Creates S3 state bucket + DynamoDB lock table
set -euo pipefail

AWS_REGION=${AWS_REGION:-us-east-1}
PROJECT=${PROJECT_NAME:-aws-devops-pipeline}
BUCKET="${PROJECT}-terraform-state-$(aws sts get-caller-identity --query Account --output text)"
DYNAMO_TABLE="${PROJECT}-terraform-lock"

echo "==> Creating Terraform state bucket: $BUCKET"
aws s3api create-bucket \
  --bucket "$BUCKET" \
  --region "$AWS_REGION" \
  --create-bucket-configuration LocationConstraint="$AWS_REGION" 2>/dev/null || true

aws s3api put-bucket-versioning \
  --bucket "$BUCKET" \
  --versioning-configuration Status=Enabled

aws s3api put-bucket-encryption \
  --bucket "$BUCKET" \
  --server-side-encryption-configuration '{
    "Rules": [{"ApplyServerSideEncryptionByDefault": {"SSEAlgorithm": "AES256"}}]
  }'

aws s3api put-public-access-block \
  --bucket "$BUCKET" \
  --public-access-block-configuration \
    "BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true"

echo "==> Creating DynamoDB lock table: $DYNAMO_TABLE"
aws dynamodb create-table \
  --table-name "$DYNAMO_TABLE" \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST \
  --region "$AWS_REGION" 2>/dev/null || true

echo "==> Update terraform/main.tf backend block:"
echo "      bucket         = \"$BUCKET\""
echo "      dynamodb_table = \"$DYNAMO_TABLE\""
echo "      region         = \"$AWS_REGION\""
echo ""
echo "✅ Bootstrap complete. Run: terraform init"
