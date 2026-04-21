#!/bin/bash
set -e

echo "=== Project Stratum — Destroying all infrastructure ==="
echo "WARNING: This will destroy all AWS resources."
read -p "Are you sure? Type 'yes' to confirm: " confirm

if [ "$confirm" != "yes" ]; then
  echo "Aborted."
  exit 1
fi

cd terraform/environments/dev
terraform destroy -auto-approve

echo "All infrastructure destroyed."
