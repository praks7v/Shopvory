step 01: git clone project
step 02: Install gcloud, terraform and kubectl
    - ./install_terraform.sh
    - ./install_gcloud.sh
    - ./install_kubectl.sh
    
step 03: configure gcloud
    - gcloud auth login --no-launch-browser
    - <copy the link and paste it to browser then login google account then paste code to cli>
    - gcloud auth application-default login
    - gcloud config set account `ACCOUNT` (optional)
    - gcloud auth list
    - gcloud projects list
    - gcloud config set project <PROJECT-ID>
    - gcloud config get-value project
    
step 04: create infra using terraform
    - ./create_cicd_infra.sh
    - ./create_gke_infa.sh
    
step 05: add credentials and configure tools for jenkins
    - create account and 
    - install plugins:
        - docker
        - kubenetes, cli
        - mulibrach webhooks
        
    - configure credentials:
        - add docker hub cred
        - add github cred
        - create svc key ```gcloud iam service-accounts keys create ~/jenkins-sa-key.json --iam-account=jenkins-sa@<PROJECT_ID>.iam.gserviceaccount.com```

        - add jenkins service account key file
        - create mulibrach pipeline with github webhooks
        
step 06: verify or dubug
    - verify application 

step 07: destroy infra
    - cd scripts
    - ./destroy_cicd_infra.sh
    - ./destroy_gke_infra.sh
    
    
    
