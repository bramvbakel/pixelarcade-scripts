# Discord Notification Script

This script (`notify_discord.sh`) sends a message to a Discord channel using a webhook URL. It is useful for sending notifications (e.g., after a backup completes) from your scripts or server.

## How It Works
- Loads the Discord webhook URL from a `.env` file.
- Sends a message (provided as the first argument) to the Discord channel via the webhook.

## Usage

1. Create your own `.env` file using the provided template:
   ```bash
   cp .env.example .env
   # Edit .env to set DISCORD_WEBHOOK_URL with your own value
   ```
2. Make the script executable:
   ```bash
   chmod +x notify_discord.sh
   ```
3. Send a message:
   ```bash
   ./notify_discord.sh "Backup completed successfully!"
   ```
   If no message is provided, it will send "Backup completed successfully." by default.

## Environment Variables

Create a `.env` file in the same directory as the script with the following variable:

```env
DISCORD_WEBHOOK_URL="https://discord.com/api/webhooks/your-webhook-id/your-webhook-token"
```

You can use `.env.example` as a template.

## Notes
- The script requires `curl` to be installed.
- The webhook URL is sensitive; do not share your `.env` file publicly.
