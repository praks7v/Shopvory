# GCP Infrastructure Setup using Terraform, Ansible, and Jenkins

This guide outlines the process of setting up Google Cloud Platform (GCP) infrastructure, configuring Terraform and Ansible, and deploying a CI/CD pipeline using Jenkins.

---

### Prerequisites
Ensure the following tools are installed on your local or remote machine:
- **Google Cloud SDK**: [Installation Guide](https://cloud.google.com/sdk/docs/install)
- **Terraform**: [Installation Guide](https://www.terraform.io/downloads)
- **Ansible**: [Installation Guide](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)
- **Jenkins**: [Installation Guide](https://www.jenkins.io/download/)

---

## Step 1: Google Cloud Setup

### Install Google Cloud SDK
To install the Google Cloud SDK, use the following script:

```bash
chmod +x ./scripts/install_gcloud.sh
./scripts/install_gcloud.sh
```

### Authenticate with GCP
To authenticate with GCP:

```bash
gcloud auth application-default login
```

> **Note**: For headless servers or CI environments, use:

```bash
gcloud auth application-default login --no-launch-browser
```

### Create a New GCP Project

1. **List your billing accounts**:
   This will display all billing accounts available in your GCP account:

    ```bash
    gcloud beta billing accounts list
    ```

2. **Create a new project**:
   Replace `<PROJECT_ID>` and `<PROJECT_NAME>` with your values:

    ```bash
    gcloud projects create <PROJECT_ID> --name="<PROJECT_NAME>"
    # Example:
    gcloud projects create shopvory-ecommerce --name="Shopvory"
    ```

3. **Link project to billing account**:
   Replace `<ACCOUNT_ID>` with your billing account ID:

    ```bash
    gcloud beta billing projects link <PROJECT_ID> --billing-account=<ACCOUNT_ID>
    ```

4. **Set project as the default**:

    ```bash
    gcloud config set project <PROJECT_ID>
    ```

5. **Verify project configuration**:

    ```bash
    gcloud config get-value project
    ```

    Expected output:

    ```bash
    shopvory-ecommerce
    ```

### Enable Required APIs
Run the following command to enable all necessary APIs:

```bash
gcloud services enable compute.googleapis.com \
    container.googleapis.com \
    storage.googleapis.com \
    cloudresourcemanager.googleapis.com
```

---

## Step 2: Terraform & Ansible Setup

### Install Terraform

Use this script to install Terraform:

```bash
chmod +x scripts/install_terraform.sh
./scripts/install_terraform.sh
```

### SSH Key Generation for Ansible

Generate SSH keys for Ansible connections:

```bash
ssh-keygen -t ed25519 -f ~/.ssh/ansible_ed25519 -C ansible
```

### Ansible Configuration

Configure Ansible to use the generated SSH keys:

1. Open your `ansible.cfg` file and add the following configuration:

    ```ini
    [defaults]
    inventory = inventory/ansible_inventory.json
    remote_user = ansible
    private_key_file = ~/.ssh/ansible_ed25519
    ```

### Step 1. Create Infrastructure with Terraform

Before creating the infrastructure, review and edit the `backend.tf` and `terraform.tfvars` files:

- **Example `backend.tf` for CI/CD infrastructure**:
    ```hcl
    terraform {
      backend "gcs" {
        bucket = "tf-state-file-cicd"
        prefix = "terraform/state"
      }
      required_providers {
        google = {
          source  = "hashicorp/google"
          version = "~> 6.0"
        }
      }
    }
    ```

- **Example `terraform.tfvars` for CI/CD infrastructure**:
    ```hcl
    # VPC Networ
   project_id   = "shopvory-ecommerce"
   network_name = "cicd-vpc"
   
   # VM instances
   instance_image = "projects/ubuntu-os-cloud/global/images/ubuntu-2004-focal-v20240829"
   
   region = "asia-south1"
   
   ssh_user       = "ansible"
   ssh_public_key = "/home/dev/.ssh/ansible_ed25519.pub"
   
   vm_instances = [
     {
       name         = "jenkins-vm"
       machine_type = "e2-standard-4"
       zone         = "asia-south1-a"
       disk_size    = 20
     }
   ]
    ```

To create the CI/CD infrastructure:

```bash
cd scripts
chmod +x create_cicd_infra.sh
./create_cicd_infra.sh
```

### Step 2: Configure GKE Infrastructure with Terraform
Create Terraform Configuration for GKE
Backend Configuration:
The backend is where Terraform stores its state. In this example, Terraform state is stored in a Google Cloud Storage bucket.

Create a `backend.tf` file for GKE infrastructure, using the following configuration:

```hcl
Copy code
terraform {
  backend "gcs" {
    bucket = "tf-state-file-cicd"  # Replace with your GCS bucket
    prefix = "terraform/state/gke"
  }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"
    }
  }
}
```
Variable Configuration:
Next, define the variables for your GKE environment in a `terraform.tfvars` file:
```
project_id   = "shopvory-ecommerce"
network_name = "gke-prod-vpc"
region       = "asia-south1"
zone         = "asia-south1-b"
```
To create the GKE infrastructure:

```bash
cd scripts
chmod +x create_gke_infra.sh
./create_gke_infra.sh
```
---

## Step 3: Jenkins Setup

### Install Jenkins Plugins

Install the following plugins from the Jenkins dashboard:
- Docker
- Docker Pipeline
- Kubernetes CLI
- Multibranch Pipeline Webhook
- SonarQube Scanner

### Configure Jenkins Credentials

1. **Docker Hub credentials**: Store your Docker Hub credentials for pushing and pulling images.
2. **GCP service account JSON key**: Add the GCP service account key to interact with GCP.
3. **GitHub credentials**: For source control access.
4. **SonarQube credentials**: To communicate with SonarQube.

### Example Jenkinsfile for Pipeline

Here’s an example `Jenkinsfile` with environment variables for GCP authentication and Kubernetes deployment:

```groovy
pipeline {
    agent any
    environment {
        PROJECT_ID = 'shopvory-ecommerce'
        CLUSTER_NAME = 'prod-cluster'
        CLUSTER_ZONE = 'asia-south1-b'
        GOOGLE_APPLICATION_CREDENTIALS = credentials('jenkins-sa-key')
        KUBE_CONFIG = 'kubeconfig'
        USE_GKE_GCLOUD_AUTH_PLUGIN = 'True'
    }
    stages {
        stage('Build') {
            steps {
                script {
                    sh 'gcloud auth activate-service-account --key-file=$GOOGLE_APPLICATION_CREDENTIALS'
                    sh 'gcloud container clusters get-credentials $CLUSTER_NAME --zone $CLUSTER_ZONE --project $PROJECT_ID'
                    sh 'kubectl apply -f deployment-service.yml'
                }
            }
        }
    }
}
```

### Configure Webhooks

To trigger the Jenkins pipeline on GitHub events:

1. Go to **Settings** > **Webhooks** in your GitHub repository.
2. Set the Payload URL to:

    ```text
    http://<jenkins-url>/github-webhook/
    ```

3. Select **application/json** for Content type.
4. Choose the events to trigger the pipeline (e.g., "Push events").
5. Add the webhook.

---

## Step 4: Cleanup Infrastructure

When you're done, clean up the infrastructure:

1. **CI/CD and GKE**:

    ```bash
    cd scripts
    chmod +x destroy_cicd_infra.sh destroy_gke_infra.sh
    ./destroy_cicd_infra.sh
    ./destroy_gke_infra.sh
    ```

2. **Delete the GCP Storage Bucket**:

    ```bash
    gcloud storage rm -r gs://<BUCKET_NAME>
    ```

3. **Delete the GCP project**:

    ```bash
    gcloud projects delete <PROJECT_ID>
    ```

---

## Conclusion

By following this guide, you can quickly set up, deploy, and manage GCP infrastructure, CI/CD pipelines using Jenkins, and orchestrate resources with Terraform and Ansible. When no longer needed, remember to clean up the environment to avoid unnecessary costs.
