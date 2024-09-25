# GCP Infrastructure Setup using Terraform, Ansible, and Jenkins

This guide provides step-by-step instructions to set up Google Cloud Platform (GCP) infrastructure, configure Terraform and Ansible, and deploy a CI/CD pipeline using Jenkins. The steps are divided into phases for easy navigation.

## Prerequisites
Ensure that the following tools are installed:
- [Google Cloud SDK](https://cloud.google.com/sdk/docs/install)
- [Terraform](https://www.terraform.io/downloads)
- [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)
- [Jenkins](https://www.jenkins.io/download/)
  
---
## Step 01: Google Cloud Setup

### Install Google Cloud SDK
To install the Google Cloud SDK, run:
```bash
chmod +x ./scripts/install_gcloud.sh
./scripts/install_gcloud.sh
```
### Authenticate with GCP
Authenticate to GCP by running:

```bash
gcloud auth application-default login
```
In certain environments (like headless servers), you can use the following command: (optional)

```bash
gcloud auth application-default login --no-launch-browser
```
## Billing and Project Setup
1. List your existing billing accounts:
This will list all billing accounts you can use with GCP:

```bash
gcloud beta billing accounts list
```
2. Create a new project:
Replace `<PROJECT_ID>` and `<PROJECT_NAME>` with your desired values. For example:

```bash
gcloud projects create <PROJECT_ID> --name="<PROJECT_NAME>"
# Example:
gcloud projects create shopvory-ecommerce --name="Shopvory"
```
3. Link the project to a billing account:
Replace `<ACCOUNT_ID>` with your billing account ID:

```bash
gcloud beta billing projects link <PROJECT_ID> --billing-account=<ACCOUNT_ID>
```
4. Set the project as the default project:
Configure your environment to use this project as the default:

```bash
gcloud config set project <PROJECT_ID>
```
5. Verify the project setup:
To check that the project has been set correctly, run:

```bash
gcloud config get-value project
# Expected output: shopvory-ecommerce
```

### Enable Required APIs
Enable the necessary Google Cloud services:

```bash
chmod +x scripts/gcp_service_apis.sh
scripts/gcp_service_apis.sh
```
or 
```bash
gcloud services enable compute.googleapis.com
gcloud services enable container.googleapis.com
gcloud services enable storage.googleapis.com
gcloud services enable cloudresourcemanager.googleapis.com
```
### Google Cloud Storage Setup
Create a storage bucket:

```bash
gcloud storage buckets create gs://YOUR_BUCKET_NAME --location=REGION
```
(Optional) Enable versioning for the bucket:

```bash
gcloud storage buckets update gs://YOUR_BUCKET_NAME --versioning
```
### Service Account Creation

To manage infrastructure with Terraform, you'll need to create a dedicated service account in GCP. You can either create the service account by running a script or manually through the Google Cloud Console.

#### Option 1: Create a Service Account using a Script

Follow these steps to create a Terraform service account via the provided script:

1. Set your GCP project ID and service account name as environment variables:

    ```bash
    PROJECT_ID="shopvory-ecommerce"
    SERVICE_ACCOUNT_NAME="tf-svc-account"
    ```

2. Ensure the script has executable permissions:

    ```bash
    chmod +x scripts/create_tf_svc_account.sh
    ```

3. Run the script to create the service account:

    ```bash
    ./scripts/create_tf_svc_account.sh
    ```

> **Note:** Before running the script, make sure to edit it with the correct roles, permissions, and project-specific details as necessary.

#### Option 2: Manual Creation via the GCP Console

Alternatively, you can manually create a service account through the Google Cloud Console or the `gcloud` CLI by following these steps:

1. Create the service account:

    ```bash
    gcloud iam service-accounts create $SERVICE_ACCOUNT_NAME \
      --display-name="Terraform Service Account"
    ```

2. Assign the required roles and permissions to the service account. For example, to grant the `roles/editor` role:

    ```bash
    gcloud projects add-iam-policy-binding $PROJECT_ID \
      --member="serviceAccount:$SERVICE_ACCOUNT_NAME@$PROJECT_ID.iam.gserviceaccount.com" \
      --role="roles/editor"
    ```

3. (Optional) If you want to use more fine-grained permissions, assign specific roles as needed based on the scope of the infrastructure your Terraform configuration will manage.

> For more details on available roles, refer to the [Google Cloud IAM Documentation](https://cloud.google.com/iam/docs/understanding-roles).

---
## Step 02: Terraform & Ansible Setup
Install Terraform
Run the following script to install Terraform:

```bash
chmod +x scripts/install_terraform.sh
./scripts/install_terraform.sh
```
SSH Key Generation for Ansible
Generate SSH keys for Ansible:

```bash
ssh-keygen -t ed25519 -f ~/.ssh/ansible_ed25519 -C ansible
```

Ansible Configuration

Add the following configuration to your Ansible settings (e.g., in `ansible.cfg`):

```ini
[defaults]
inventory = inventory/ansible_inventory.json
remote_user = ansible
private_key_file = /home/dev/.ssh/ansible_ed25519
```
Create GCP Infrastructure with Terraform

Run the Scripts to Create Infrastructure

1. Create CI/CD Infrastructure

To set up the CI/CD infrastructure, run the following script:

```bash
cd scripts
chmod +x create_cicd_infra.sh
./create_cicd_infra.sh
```
2. Create GKE Infrastructure
To create the GKE (Google Kubernetes Engine) infrastructure, run the following script in the background:

```bash
chmod +x create_gke_infra.sh
./create_gke_infra.sh &
```

---
## Step 03: Jenkins Setup

### Initial Jenkins Configuration
1. Install Jenkins and configure default plugins.
2. Login to Jenkins and configure it as needed.

### Install Jenkins Plugins
Install the following Jenkins plugins:
- Docker
- Docker Pipeline
- Kubernetes
- Kubernetes CLI
- Multibranch Pipeline Webhook
- SonarQube Scanner
  
### Configure Jenkins Tools
- Docker
- SonarQube
  
### Add Credentials in Jenkins
- **Docker Hub credentials**: Store your Docker Hub credentials to allow Jenkins to push/pull images.
- **Jenkins service account JSON key**: Add the GCP service account key to interact with GCP resources.
- **GitHub credentials**: Store GitHub credentials for source control access.
- **SonarQube credentials**: Add credentials to allow Jenkins to communicate with SonarQube.
  
### Steps to Create and Add Google Cloud Service Account Key to Jenkins:
1. Create the Service Account Key
Run the following command to generate a key for the Jenkins service account. This key will be used for authentication with GCP in the Jenkins pipeline.

```bash
gcloud iam service-accounts keys create ~/jenkins-sa-key.json \
--iam-account=jenkins-sa@<PROJECT_ID>.iam.gserviceaccount.com
```
Replace `<PROJECT_ID>` with your actual GCP project ID.

2. Add the Key to Jenkins

- Open your Jenkins dashboard.
- Go to Manage Jenkins > Manage Credentials > (global).
- Click on Add Credentials.
- Select Secret file as the kind.
- Upload the `jenkins-sa-key.json` file generated in step 1.
- Set the ID to something descriptive, like `jenkins-sa-key`.
  
3. Use the Credentials in Jenkins Pipelines
In your Jenkinsfile, you can now reference the credentials using the ID you set when adding them to Jenkins.

**Example Jenkinsfile with Environment Variables**
The following environment variables are used to configure the deployment pipeline:

```groovy
pipeline {
    agent any
    environment {
        PROJECT_ID = 'shopvory-ecommerce'  // GCP Project ID
        CLUSTER_NAME = 'prod-cluster'  // GKE Cluster name
        CLUSTER_ZONE = 'asia-south1-b'  // GKE Cluster zone
        GOOGLE_APPLICATION_CREDENTIALS = credentials('jenkins-sa-key')  // Service account key file stored in Jenkins
        KUBE_CONFIG = 'kubeconfig'  // Kubernetes config file
        USE_GKE_GCLOUD_AUTH_PLUGIN = 'True'  // Required for GKE authentication via gcloud plugin
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
### Environment Variable Descriptions:
- `PROJECT_ID`: The Google Cloud Project ID where your resources are hosted.
- `CLUSTER_NAME`: The name of the Google Kubernetes Engine (GKE) cluster where the application will be deployed.
- `CLUSTER_ZONE`: The zone where your GKE cluster is located. Example: `asia-south1-b`.
- `GOOGLE_APPLICATION_CREDENTIALS`: The service account key stored in Jenkins for authenticating with GCP. This uses the credential ID added in Jenkins.
- `KUBE_CONFIG`: The Kubernetes config file that `kubectl` uses to interact with the GKE cluster.
- `USE_GKE_GCLOUD_AUTH_PLUGIN`: This ensures that `kubectl` uses the GKE gcloud authentication plugin when accessing the cluster.
- 
### Create a Pipeline in Jenkins
1. In Jenkins, click New Item.
2. Enter a name for the pipeline (e.g., MyProjectPipeline).
3. Select Pipeline and click OK.
4. In the Pipeline section:
    - Under Definition, select "Pipeline script from SCM".
    - Select Git as the SCM.
    - Enter the repository URL.
    - Add any required credentials for the repository.
    - Set the Script Path to Jenkinsfile (if it’s located in the root of the repository).
5. Save the pipeline configuration.

### Configure Webhooks
To trigger the pipeline automatically on GitHub events:

1. In your GitHub repository, go to Settings > Webhooks > Add webhook.

2. Set the Payload URL to your Jenkins URL, followed by `/github-webhook/`:

```text
http://your-jenkins-url/github-webhook/
```
3. Set the Content type to `application/json`.

4. Select the events to trigger the webhook (e.g., "Just the push event").

5. Click Add webhook.

---
## Step 04: Destroying the Infrastructure
Cleanup CI/CD and GKE Infrastructure
Run the following scripts to destroy the infrastructure:

```bash
cd scripts
chmod +x destroy_cicd_infra.sh
 ./destroy_cicd_infra.sh
chmod +x destroy_gke_infra.sh
./destroy_gke_infra.sh
```
Delete the GCP Storage Bucket
Delete the Terraform state bucket and its contents:

```bash
gcloud storage rm -r gs://<BUCKET_NAME>
gcloud storage buckets delete gs://<BUCKET_NAME>
```
Delete the GCP Project
Finally, delete the GCP project:

```bash
gcloud projects delete <PROJECT_ID>
```
---
## Conclusion
This guide helps you to quickly set up GCP infrastructure, CI/CD pipelines using Jenkins, and manage resources using Terraform and Ansible. Follow the cleanup steps to tear down the environment when it is no longer needed.


