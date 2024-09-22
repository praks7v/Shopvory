step 01: 
    - install glcoud (./scripts/install_gcloud.sh)
    - gcloud auth application-default login
    - gcloud auth application-default login --no-launch-browser (optional special case)
    - gcloud beta billing accounts list
    - gcloud projects create <PROJECT_ID> --name="<PROJECT_NAME>"
    - gcloud projects create shopvory-ecommerce --name=shopvory
    - gcloud beta billing projects link <PROJECT_ID> --billing-account=<ACCOUNT_ID>
    - gcloud config set project <PROJECT_ID>
    - gcloud config get-value project
    - gcloud services enable compute.googleapis.com (./scripts/gcp_service_apis.sh)
    - gcloud services enable container.googleapis.com
    - gcloud services enable storage.googleapis.com
    - gcloud projects list
    - gcloud config set account `ACCOUNT` (optional)
    - gcloud storage buckets create gs://YOUR_BUCKET_NAME --location=REGION
    - gcloud storage buckets update gs://YOUR_BUCKET_NAME --versioning (optional but recommended)
    - create terraform service account (./scripts/create_tf_svc_account.sh - edit before running)
    
step 02: Terraform & ansible 
    - install terraform (./scripts/install_terraform.sh)
    - ssh-keygen -t ed25519 -f ~/.ssh/ansible_ed25519 -C ansible (ansible)
    - cd scripts 
    - chmod +x create_cicd_infra.sh
    - ./create_cicd_infra.sh
    - ./create_gke_infra.sh &
    
step 03: Jenkins
    - install default plugins and login configure
    - install plugins:
        - docker 
        - kubernetes
        - cli
        - mulipipeline webhook
        - sonarqube
    - add credentials:
        - docker hub credentials
        - jenkins service account cred file (json)
        - github credentials
        - sonarqube credentials
    - configure tools:
        - docker
        - nodejs
        - sonarqube
    - run the pipeline
    - run form webhook
    
step 04: destroy
    - cd scripts
    - ./destroy_cicd.sh
    - ./destroy_gke_infra.sh
    - gcloud storage rm -r gs://tf-state-file-cicd && gcloud storage buckets delete gs://tf-state-file-cicd

    - gcloud projects delete <PROJECT_ID>


    