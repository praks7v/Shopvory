#!/bin/bash

# Print starting message
echo "Starting Terraform cicd deployment..."

# Run Terraform to create infrastructure
cd ../terraform/environments/cicd
echo "Initializing Terraform..."
terraform init

echo "Applying Terraform configuration..."
terraform apply -auto-approve

# Export Terraform output to JSON
echo "Exporting Terraform output to JSON..."
terraform output -json > ../../../ansible/inventory/terraform_output.json

# Print message before running Ansible playbook
echo "Running Ansible playbook using dynamic inventory..."

# Run Ansible playbook using dynamic inventory
cd ../../../ansible
echo "Making terraform_inventory.py executable..."
chmod +x inventory/terraform_inventory.py

echo "Generating inventory..."
./inventory/terraform_inventory.py

echo "Making add_known_hosts.sh executable..."
chmod +x add_known_hosts.sh

echo "Adding known hosts..."
./add_known_hosts.sh

echo "Waiting for 10 seconds before running Ansible playbook..."
sleep 10

# Run the Ansible playbook
echo "Running Ansible playbook..."
ansible-playbook -i inventory/ansible_inventory.json playbooks/main.yml

# Print completion message
echo "Deployment script completed successfully."
