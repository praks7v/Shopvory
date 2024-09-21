pipeline {
    agent any

    environment {
        PROJECT_ID = 'praks-dev'
        CLUSTER_NAME = 'prod-cluster'
        CLUSTER_ZONE = 'asia-south1-b'
        GOOGLE_APPLICATION_CREDENTIALS = credentials('jenkins-sa-key')  // Service account key file
        KUBE_CONFIG = 'kubeconfig'
        USE_GKE_GCLOUD_AUTH_PLUGIN = 'True'  // Set the environment variable for kubectl
    }

    stages {
        stage('Authenticate with GCP') {
            steps {
                script {
                    // Authenticate with Google Cloud
                    sh 'gcloud auth activate-service-account --key-file=${GOOGLE_APPLICATION_CREDENTIALS}'
                }
            }
        }

        stage('Get GKE Credentials') {
            steps {
                script {
                    // Fetch credentials to interact with GKE cluster
                    sh '''
                    gcloud container clusters get-credentials ${CLUSTER_NAME} \
                      --zone ${CLUSTER_ZONE} \
                      --project ${PROJECT_ID}
                    '''
                }
            }
        }

        stage('Deploy to GKE') {
            steps {
                script {
                                                   
                    // Deploy Kubernetes manifests using kubectl
                    sh '''
                    kubectl apply -f deployment-service.yml
                    sleep 60
                    '''
                }
            }
        }

        stage('Verify Deployment') {
            steps {
                script {
                    // Verify that the deployment is successful
                    sh '''
                    kubectl get pods
                    kubectl get svc
                    '''
                }
            }
        }
    }
}
