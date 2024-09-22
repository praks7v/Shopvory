#!/bin/bash
set -e  # Exit immediately if a command exits with a non-zero status

# Define variables
PROJECT_ID="shopvory-ecommerce"
SERVICE_ACCOUNT_NAME="tf-svc-account"
SERVICE_ACCOUNT_EMAIL="$SERVICE_ACCOUNT_NAME@$PROJECT_ID.iam.gserviceaccount.com"
KEY_FILE_PATH="$HOME/.ssh/$SERVICE_ACCOUNT_NAME.json"

# Create the service account
gcloud iam service-accounts create $SERVICE_ACCOUNT_NAME \
  --description="Service account with necessary permissions" \
  --display-name="terraform service account" \
  --quiet

# Assign roles with conditions for non-basic roles
gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:$SERVICE_ACCOUNT_EMAIL" \
  --role="roles/compute.networkAdmin" \
  --condition="title=expires_after_2024_11_11,expression=request.time < timestamp('2024-11-11T00:00:00Z')" \
  --quiet

gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:$SERVICE_ACCOUNT_EMAIL" \
  --role="roles/resourcemanager.projectIamAdmin" \
  --condition="title=expires_after_2024_11_11,expression=request.time < timestamp('2024-11-11T00:00:00Z')" \
  --quiet

gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:$SERVICE_ACCOUNT_EMAIL" \
  --role="roles/iam.serviceAccountAdmin" \
  --condition="title=expires_after_2024_11_11,expression=request.time < timestamp('2024-11-11T00:00:00Z')" \
  --quiet

# Assign roles without conditions (set condition to None)
gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:$SERVICE_ACCOUNT_EMAIL" \
  --role="roles/editor" \
  --condition=None \
  --quiet

# Create the key in the .ssh directory
gcloud iam service-accounts keys create $KEY_FILE_PATH \
  --iam-account=$SERVICE_ACCOUNT_EMAIL \
  --quiet

# Set permissions on the key file
chmod 600 $KEY_FILE_PATH

# Export Google application credentials
export GOOGLE_APPLICATION_CREDENTIALS="$KEY_FILE_PATH"
