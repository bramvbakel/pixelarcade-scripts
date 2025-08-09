#!/bin/bash
# Sends a message to a Discord channel using a webhook URL from .env

# Load environment variables from .env if it exists
if [ -f .env ]; then
  set -a
  . ./.env
  set +a
fi

if [ -z "$DISCORD_WEBHOOK_URL" ]; then
  echo "Error: DISCORD_WEBHOOK_URL is not set. Please set it in the .env file."
  exit 1
fi

MESSAGE=${1:-"Backup completed successfully."}

curl -H "Content-Type: application/json" \
     -X POST \
     -d "{\"content\": \"$MESSAGE\"}" \
     "$DISCORD_WEBHOOK_URL"
