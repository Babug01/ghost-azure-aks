# Ghost Application Infrastructure on Azure

Welcome to the repository containing the infrastructure setup for hosting the Ghost application on Microsoft Azure. This document provides an overview of the architecture, deployment steps, high availability features, and considerations for the project.

## Folder Structure

```
├── config     # terraform.tfvars for creating resources
├── ghostapp   # dockerfile to build ghost app
├── helm       # helm charts for ghost app and values.yaml file
├── pipelines  # pipelines for infra & service deployment
└── terraform  # terraform configurations for creating azure resources
```

## Infrastructure for Ghost

This repository contains an terraform configuration that deploys and configures the required Azure resources for hosting a ghost application. The infrastructure is designed to fulfill the following requirements:

- Scalability to handle varying loads.
- Consistent application behavior across user sessions.
- Resilient architecture for high availability.
- Observability for monitoring and diagnostics.
- Automated deployment of resources.
- Utilizes Azure Cloud services for the entire infrastructure.

## Infrastructure Diagram

([Azure Infrastructure](infra.drawio))

## Deployment Steps

### Prerequisites

- Active Azure subscription
- Azure Devops subscription
- Installed kubectl & terraform

### Azure Resources Setup

The terraform folder in this repository provisions the following resources:

- **Azure Container Registry**: Securely store and manage Docker container images, enabling controlled distribution and integration with Azure Kubernetes Service (AKS).
- **Azure Key Vault**: Centrally manage secrets and keys, enhancing security by avoiding direct embedding in code and simplifying secret rotation.
- **Azure Kubernetes Service (AKS)**: Effortlessly deploy, manage, and scale containerized applications using Kubernetes, with availability zones ensuring high availability.
- **Azure Database for MySQL Flexible Server**: Achieve fully managed MySQL databases with high availability, simplifying maintenance and data resilience.
- **Application Insights**: Gain insights into application performance, usage, and errors, enabling proactive optimization and diagnostics.
- **Log Analytics Workspace**: Centrally collect, analyze, and visualize logs for applications and infrastructure, aiding in troubleshooting and observability.
- **Azure Storage Account:** Serves the Ghost site contents.

## Ghost App + Application Insights Integration

[**Custom Ghost Docker image**](https://learn.microsoft.com/en-us/azure/container-registry/) that uses the [**original Ghost image**](https://hub.docker.com/_/ghost) as the base one and extends it with Azure Application Insights support.

- Created Dockerfile with Ghost app and application insights configuration
- Need to add few details in **config.development.json** file about database, storage and mail settings.

## Ghost Application Deployment

1. **Docker Build:**

   - Build the Docker image using the provided Dockerfile and push into **ACR**

2. **Helm Deployment:**
   - Deploy the Ghost application using Helm charts in the `helm/ghost` directory.
   - Implemented Horizontal Pod Autoscaling (HPA) for the Ghost application.

### Scaling, Resilience, and Observability

- Enabled autoscaling for the AKS node pool to dynamically adjust resources based on application load.
- AKS cluster utilizes availability zones for high availability.
- Application Insights and Log Analytics provide monitoring and logging for observability.
- Azure Database for MySQL Flexible Server Offers high availability configurations like geo-replication and automated backups.
- The Log Analytics workspace provides centralized monitoring and analytics for the application's logs and telemetry data.
- Application Insights provides real-time insights into the application's performance, user behavior, and exceptions.

## Automation and Pipelines

- Utilize Azure DevOps pipelines for automating deployment workflows.
- See the `pipelines` directory for infrastructure and service pipeline examples.

## Need Attention before running infrastructure pipeline

- Go to **terraform/\_bootstrap** folder and follow [README.md] to create storage account for storing terraform state files
- Please update Resource Group, Subscription ID & Tenant ID on configuration files available on **config/** folder
- Need to check **data.tf** file to specified data sources there because some resources won't created without for datas
- Create **Variable groups: azure-deploy & terraform-global** in azure devops library section which should has value for Service principal secrets. It will be used for running azure pipelines against azure cloud.

## Considerations

- **High Availability Strategy:** Evaluate the feasibility of multi-region redundancy to ensure business continuity in case of a regional outage.
- **Backup and Disaster Recovery:** Implement regular data backups for both application and database components. Define a disaster recovery plan to restore services in case of unexpected failures.
- **Security and Compliance:** Implement proper security controls, encryption mechanisms, and adhere to compliance standards relevant to your application's data and user privacy.
- **Cost Optimization:** Regularly review and optimize the resource allocation to control costs, considering scaling down resources during periods of lower demand.
- **Continuous Monitoring and Alerts:** Set up monitoring alerts for critical metrics and implement a process for continuous monitoring of the application's health and performance.
- **Update and Patch Management:** Establish a strategy for applying updates, patches, and security fixes to the application, container images, and underlying infrastructure.
- **Documentation and Runbooks:** Maintain comprehensive documentation and runbooks for the deployment, configuration, and operational procedures of the entire infrastructure.

## Reference Documents

- [Ghost Website](https://ghost.org/)
- [Ghost Documentation](https://ghost.org/docs/)
- [Ghost Docker Image](https://hub.docker.com/_/ghost)
- [Terraform Azure Documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [Azure Documentation](https://learn.microsoft.com/en-us/docs/)

---
