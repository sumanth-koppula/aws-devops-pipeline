#!/bin/bash
# ── destroy.sh — Safe teardown ────────────────────────────────────────
set -euo pipefail

echo "⚠️  WARNING: This will DESTROY all P9 infrastructure."
read -rp "Type 'yes' to confirm: " CONFIRM
[[ "$CONFIRM" != "yes" ]] && { echo "Aborted."; exit 0; }

echo "==> Removing Helm releases from EKS"
helm uninstall nodejs-app              --namespace default    2>/dev/null || true
helm uninstall kube-prometheus-stack   --namespace monitoring 2>/dev/null || true

echo "==> Removing leftover Kubernetes resources"
kubectl delete pvc --all -n monitoring 2>/dev/null || true

echo "==> Terraform destroy"
cd terraform
terraform destroy -auto-approve
cd ..

echo "✅ All P9 resources destroyed."