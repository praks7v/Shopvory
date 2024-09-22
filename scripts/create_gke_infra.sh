#!/bin/bash

# Define environments
environments=("prod")

# Function to run Terraform commands for a given environment
run_terraform() {
    local env=$1
    echo "Starting Terraform for environment: $env"
    
    cd "../environments/$env" || exit 1
    
    # Initialize Terraform
    terraform init
    
    # Plan Terraform changes
    terraform plan
    
    # Apply Terraform changes
    terraform apply -auto-approve
    
    # Return to the root directory
    cd - || exit 1
}

export -f run_terraform

# Run Terraform in parallel for all environments
for env in "${environments[@]}"; do
    run_terraform "$env" &
done

# Wait for all background processes to complete
wait

echo "Terraform operations completed for all environments."

