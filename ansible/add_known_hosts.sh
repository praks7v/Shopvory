#!/bin/bash

# Define the path to the JSON file
json_file="../ansible/inventory/ansible_inventory.json"

# Use jq to extract ansible_host values from the JSON file
hosts=$(jq -r '.all.hosts[] | .ansible_host' "$json_file")

# Loop through each extracted host and add its key to known_hosts
for host in $hosts; do
  ssh-keyscan -H "$host" >> ~/.ssh/known_hosts
done
