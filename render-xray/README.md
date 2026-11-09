# render-xray

Xray (VLESS + WebSocket) running on Render's free tier. Same pattern as the
Cloady node: the official xray image has no shell, so a multi-stage Dockerfile
copies the xray binary into Alpine. Render terminates TLS outside the
container (443 -> `$PORT`); xray inside only speaks plain WebSocket.

## Deploy

Render Dashboard -> New -> Web Service -> Build and deploy from a Git
repository -> pick this repo. Render auto-detects the Dockerfile.

- **Region:** Singapore (closest to China; Oregon works too)
- **Instance Type:** Free (512 MB RAM, 0.1 vCPU; xray uses ~20 MB)
- **Environment variables** (set in the Render dashboard, never committed):
  - `UUID` — the VLESS client UUID
  - `WS_PATH` — the WebSocket path, e.g. `/297e3ae5bce59fac`
  - `PORT` is set automatically by Render; no need to set it.

No health-check path: Render's default port check is enough (xray accepts the
TCP connection on `$PORT`).

## Free-tier notes

- 750 instance-hours/month per workspace: one service running 24/7 uses
  ~730 h, inside the budget. Bandwidth 100 GB/month.
- The service spins down after 15 minutes without inbound traffic; a free
  keep-alive ping every 5 minutes (e.g. UptimeRobot or a cron curl) keeps it
  awake.
- No secrets live in this repo. The UUID and WS path exist only in Render's
  environment variables and in the operator's local files.
