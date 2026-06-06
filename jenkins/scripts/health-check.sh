#!/bin/bash
# Usage: health-check.sh <helm-release> <namespace> <timeout-seconds>
set -euo pipefail

RELEASE=$1
NAMESPACE=$2
TIMEOUT=${3:-60}

echo "==> Waiting for rollout: $RELEASE in $NAMESPACE"
kubectl rollout status deployment/"$RELEASE" -n "$NAMESPACE" --timeout="${TIMEOUT}s"

echo "==> Fetching service URL..."
LB_HOSTNAME=$(kubectl get svc "$RELEASE" -n "$NAMESPACE" \
  -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')

if [[ -z "$LB_HOSTNAME" ]]; then
  echo "WARNING: LoadBalancer hostname not ready; checking pod health instead"
  POD=$(kubectl get pods -n "$NAMESPACE" -l "app.kubernetes.io/name=$RELEASE" \
        -o jsonpath='{.items[0].metadata.name}')
  kubectl exec "$POD" -n "$NAMESPACE" -- \
    wget -qO- http://localhost:3000/health
else
  echo "==> Health check: http://$LB_HOSTNAME/health"
  for i in $(seq 1 10); do
    if curl -sf "http://$LB_HOSTNAME/health" > /dev/null; then
      echo "✅ Health check passed on attempt $i"
      exit 0
    fi
    echo "Attempt $i failed, retrying in 10s..."
    sleep 10
  done
  echo "❌ Health check failed after 10 attempts"
  exit 1
fi