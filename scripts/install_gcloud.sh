#!/bin/bash

echo "Updating package list..."
sudo apt-get update

echo "Installing required packages: apt-transport-https, ca-certificates, gnupg, curl..."
sudo apt-get install apt-transport-https ca-certificates gnupg curl -y

echo "Downloading and adding the Google Cloud public GPG key..."
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg

echo "Adding the Google Cloud SDK repository to your sources list..."
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list

echo "Updating package list after adding Google Cloud SDK repository..."
sudo apt-get update

echo "Installing Google Cloud CLI..."
sudo apt-get install google-cloud-cli -y

echo "Installing GKE gcloud auth plugin..."
sudo apt-get install google-cloud-sdk-gke-gcloud-auth-plugin -y

echo "Google Cloud SDK and GKE gcloud auth plugin installation completed!"
