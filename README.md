# Shopvory - E-commerce Microservices Application
Shopvory is a microservice-based ecommerce platform. Each service is designed to handle a specific domain, making the architecture highly modular and scalable. The application is deployed on Google Cloud Platform (GCP) using Infrastructure as Code (IaC) tools such as Terraform and Ansible. Jenkins is used as the Continuous Integration/Continuous Deployment (CI/CD) pipeline tool, with GitHub as the version control system integrated through webhooks.

## Table of Contents
1. Microservice Components
2. Tech Stack
3. [Infrastructure Setup](https://github.com/praks7v/Shopvory/tree/gcp-infra)
4. CI/CD Pipeline
5. [Deployment](https://github.com/praks7v/Shopvory/tree/gcp-infra/scripts)
6. Testing
7. Contributing
   
## Microservice Components
The application consists of the following services:

- [adservice](https://github.com/praks7v/Shopvory/tree/adservice)
  - Ad management and delivery.
- [cartservice](https://github.com/praks7v/Shopvory/tree/cartservice)
  - Handles shopping cart operations.
- [checkoutservice](https://github.com/praks7v/Shopvory/tree/checkoutservice)
  - Manages the checkout process.
- [currencyservice](https://github.com/praks7v/Shopvory/tree/currencyservice)
  - Currency conversion service.
- [emailservice](https://github.com/praks7v/Shopvory/tree/emailservice)
  - Handles email notifications.
- [frontend](https://github.com/praks7v/Shopvory/tree/frontend)
  - User-facing frontend service.
- [loadgenerator](https://github.com/praks7v/Shopvory/tree/loadgenerator)
  - Simulates user traffic for load testing.
- [paymentservice](https://github.com/praks7v/Shopvory/tree/paymentservice)
  - Manages payment processing.
- [productcatalogservice](https://github.com/praks7v/Shopvory/tree/productcatalogservice)
  - Product catalog and listing service.
- [recommendationservice](https://github.com/praks7v/Shopvory/tree/recommendationservice)
  - Provides personalized product recommendations.
- [shippingservice](https://github.com/praks7v/Shopvory/tree/shippingservice)
  - Handles shipping and delivery operations.
    
## Tech Stack
#### Backend
- Go and Python for microservices
- Protobuf for inter-service communication
  
### Infrastructure
- **Google Cloud Platform (GCP)**: Hosting environment
- **Terraform**: Infrastructure as Code for provisioning GCP resources
- **Ansible**: Configuration management for VM provisioning and deployment
- **Docker**: Containerization of services
- **Google Kubernetes Engine**: Deploying containerized applications

### CI/CD
- **Jenkins**: CI/CD pipeline
- **GitHub**: Version control with webhooks for triggering builds
- **GitHub Webhooks**: For automated deployment triggers
  
## [Infrastructure Setup](https://github.com/praks7v/Shopvory/tree/gcp-infra)
We use **Terraform** to provision the following GCP resources:

- VPC network for communication between services
- Virtual Machines (VMs) for hosting services
- Google Kubernetes Engine (GKE) for container orchestration
- Service Accounts and IAM permissions for secure access
  
   To see the full infrastructure setup instructions, including the Terraform configurations, Ansible Configurations, and CI/CD pipeline, please refer to the [detailed GCP infrastructure guide](https://github.com/praks7v/Shopvory/tree/gcp-infra) in the `gcp-infra` branch.
---
## Contributing
1. Fork the repository
2. Create a new branch (git checkout -b feature-branch)
3. Commit your changes (git commit -am 'Add new feature')
4. Push to the branch (git push origin feature-branch)
5. Open a pull request
