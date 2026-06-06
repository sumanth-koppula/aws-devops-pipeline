#!/bin/bash
# Usage: notify-slack.sh <message> <color: good|warning|danger>
set -euo pipefail

MESSAGE=$1
COLOR=${2:-good}
SLACK_WEBHOOK=${SLACK_WEBHOOK_URL:-""}

if [[ -z "$SLACK_WEBHOOK" ]]; then
  echo "SLACK_WEBHOOK_URL not set; skipping notification"
  exit 0
fi

PAYLOAD=$(cat <<EOF
{
  "attachments": [{
    "color":    "$COLOR",
    "text":     "$MESSAGE",
    "footer":   "Jenkins CI/CD | P9 DevOps Pipeline",
    "ts":       $(date +%s)
  }]
}
EOF
)

curl -s -X POST \
  -H 'Content-type: application/json' \
  --data "$PAYLOAD" \
  "$SLACK_WEBHOOK"