#!/bin/bash
set -e

PORT=8080

echo "Stopping existing Tailscale funnel (if any)..."
sudo tailscale funnel reset || true

echo "Stopping existing podman-compose stack..."
sudo podman-compose down || true

echo "Waiting for port $PORT to be released..."
for i in {1..10}; do
  if ! sudo ss -tlnp | grep -q ":$PORT"; then
    echo "Port $PORT is free."
    break
  fi
  echo "Port $PORT still in use, waiting..."
  sleep 1
done

# After the loop, check if port is still in use
if sudo ss -tlnp | grep -q ":$PORT"; then
  echo "Error: Port $PORT is still in use after waiting." >&2
  exit 1
fi

echo "Starting podman-compose stack..."
sudo podman-compose up -d

echo "Starting Tailscale funnel on port $PORT..."
sudo tailscale funnel --bg $PORT

echo "Done."



