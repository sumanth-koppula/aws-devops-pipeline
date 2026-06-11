#!/bin/bash
# ── deploy.sh — Full stack deploy orchestrator ────────────────────────
set -euo pipefail

ENVIRONMENT=${ENVIRONMENT:-dev}
AWS_REGION=${AWS_REGION:-us-east-1}
KEY_NAME=${KEY_NAME:-p9-key}

echo "==========================================="
echo " P9 Full DevOps Pipeline Deploy"
echo " Environment: $ENVIRONMENT"
echo " Region:      $AWS_REGION"
echo "==========================================="

# 1. Terraform
echo ""
echo "==> [1/4] Terraform: provisioning infrastructure"
cd terraform
terraform init -upgrade
terraform plan -var="environment=$ENVIRONMENT" -var="key_name=$KEY_NAME" -out=tfplan
terraform apply -auto-approve tfplan

# Capture outputs
JENKINS_IP=$(terraform output -raw jenkins_public_ip)
ECR_URL=$(terraform output -raw ecr_repository_url)
EKS_CLUSTER=$(terraform output -raw eks_cluster_name)
RDS_ENDPOINT=$(terraform output -raw rds_endpoint)
cd ..

echo "✅ Infrastructure provisioned"
echo "   Jenkins:     http://$JENKINS_IP:8080"
echo "   ECR:         $ECR_URL"
echo "   EKS Cluster: $EKS_CLUSTER"
echo "   RDS:         $RDS_ENDPOINT"

# 2. Update EKS kubeconfig
echo ""
echo "==> [2/4] Updating kubeconfig for EKS"
aws eks update-kubeconfig --region "$AWS_REGION" --name "$EKS_CLUSTER"

# 3. Install Prometheus stack
echo ""
echo "==> [3/4] Installing kube-prometheus-stack"
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm upgrade --install kube-prometheus-stack prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  --create-namespace \
  --values monitoring/prometheus/values.yaml \
  --wait --timeout 10m

# 4. Wait for Jenkins and print initial password
echo ""
echo "==> [4/4] Fetching Jenkins initial admin password"
echo "   (Wait 60s for Jenkins to start...)"
sleep 60
INITIAL_PWD=$(ssh -i ~/.ssh/$KEY_NAME.pem -o StrictHostKeyChecking=no \
  ec2-user@"$JENKINS_IP" \
  "sudo cat /var/lib/jenkins/secrets/initialAdminPassword 2>/dev/null || echo 'not ready yet'")

echo ""
echo "==========================================="
echo " ✅ P9 Deploy Complete!"
echo "==========================================="
echo " Jenkins URL:      http://$JENKINS_IP:8080"
echo " Jenkins Password: $INITIAL_PWD"
echo " Grafana:          kubectl port-forward svc/kube-prometheus-stack-grafana 3000:80 -n monitoring"
echo " Prometheus:       kubectl port-forward svc/kube-prometheus-stack-prometheus 9090:9090 -n monitoring"
echo "==========================================="