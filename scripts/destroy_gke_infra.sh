#!/bin/bash

# Define environments
environments=("prod")

# Function to run Terraform destroy for a given environment
destroy_terraform() {
    local env=$1
    echo "Starting Terraform destroy for environment: $env"

    cd "../terraform/environments/$env" || exit 1

    # Initialize Terraform
    terraform init

    # Plan the Terraform destruction
    terraform plan -destroy

    # Apply Terraform destruction
    terraform destroy -auto-approve

    # Return to the root directory
    cd - || exit 1
}

export -f destroy_terraform

# Run Terraform destroy in parallel for all environments
for env in "${environments[@]}"; do
    destroy_terraform "$env" &
done

# Wait for all background processes to complete
wait

echo "Terraform destroy operations completed for all environments."
