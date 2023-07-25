#/bin/bash
docker buildx build -t guestros/db-backup-restic:latest --platform linux/amd64,linux/arm64 --push .