#!/bin/bash
set -euo pipefail

RELEASE=$1
NAMESPACE=$2

echo "==> Waiting for rollout: $RELEASE in $NAMESPACE"
kubectl rollout status deployment/"$RELEASE-nodejs-app" -n "$NAMESPACE" --timeout=120s

echo "==> Getting pod name..."
POD=$(kubectl get pods -n "$NAMESPACE" -l "app.kubernetes.io/instance=$RELEASE" \
      -o jsonpath='{.items[0].metadata.name}')

echo "==> Testing health endpoint on pod: $POD"
kubectl exec "$POD" -n "$NAMESPACE" -- \
  wget -qO- http://localhost:3000/health

echo "✅ Health check passed!"
