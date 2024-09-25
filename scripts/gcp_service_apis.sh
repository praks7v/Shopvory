#!/bin/bash

# List of APIs to enable
apis=(
  "compute.googleapis.com"
  "container.googleapis.com"
  "monitoring.googleapis.com"
  "serviceusage.googleapis.com"
  "storage-api.googleapis.com"
  "cloudresourcemanager.googleapis.com"
)

# Enable each API
for api in "${apis[@]}"; do
  echo "Enabling $api..."
  gcloud services enable "$api"
done

echo "All APIs have been enabled."

