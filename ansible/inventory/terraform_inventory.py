#!/usr/bin/env python3
import json
import sys

def main():
    # Load the Terraform output JSON
    try:
        with open('inventory/terraform_output.json') as f:
            terraform_output = json.load(f)
    except Exception as e:
        print(f"Error loading JSON file: {e}", file=sys.stderr)
        sys.exit(1)

    # Extract the IPs
    external_ips = terraform_output.get('external_ips', {}).get('value', {})

    # Prepare inventory structure
    inventory = {
        'all': {
            'hosts': {
                hostname: {'ansible_host': ip}
                for hostname, ip in external_ips.items()
            }
        }
    }

    # Define the output file path
    output_file_path = 'inventory/ansible_inventory.json'

    # Write the inventory to a JSON file
    try:
        with open(output_file_path, 'w') as f:
            json.dump(inventory, f, indent=4)
        print(f"Inventory successfully written to {output_file_path}")
    except Exception as e:
        print(f"Error writing JSON file: {e}", file=sys.stderr)
        sys.exit(1)

if __name__ == "__main__":
    main()
