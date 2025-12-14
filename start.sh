#!/bin/bash

sudo podman-compose up -d
sudo tailscale funnel --bg 8080
