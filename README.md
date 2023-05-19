# F5 Lab

Congratulations you've made it to Jon's F5 lab. This lab environment is used daily to demonstrate various F5 products (F5XC, BIG-IP, and NGINX).

All the components of this lab are maintained through GitOps (Argo) and CI with GitHub Actions (Terraform and Ansible). The components are loosely coupled, meaning there is no carryover from one GitHub Action to another, or between Terraform and Ansible. This was done on purpose to be able to consume/copy just the needed components.

Terraform state is setup as remote, with app.terraform.io (Terraform Cloud).

[![Lab Pipeline](https://github.com/jmcalalang/lab/actions/workflows/main.yaml/badge.svg?branch=main)](https://github.com/jmcalalang/lab/actions/workflows/main.yaml)

## Environment

![image](lab.png)

## Folder Structure

### github

GitHub Actions for lab environment

- Github Actions pipeline

![image](actions.png)

- GitHub Actions breakdown
  - Argo
    - Terraform
  - BIG-IP
    - Terraform
    - Ansible
  - F5XC
    - Terraform
  - GoDaddy
    - Terraform
  - Kubernetes
    - Terraform
  - NGINX / NGINX Management System
    - Terraform
    - Ansible

- Github Actions secret table

  | **Repository secrets**          |
  |---------------------------------|
  | AD_SERVICE_LDAP_PASSWORD        |
  | AZURE_AKS_NAME                  |
  | AZURE_AKS_RG                    |
  | AZURE_APPID                     |
  | AZURE_DISPLAYNAME               |
  | AZURE_PASSWORD                  |
  | AZURE_SUBSCRIPTION              |
  | AZURE_TENANT                    |
  | BIGIP_AKS_PASSWORD              |
  | BIGIP_AKS_USER                  |
  | BIGIP_HOSTNAME                  |
  | BIGIP_PASSWORD                  |
  | BIGIP_USER                      |
  | F5XC_SITE_TOKEN                 |
  | GODADDY_API_KEY                 |
  | GODADDY_API_SECRET              |
  | NGINX_PASSWORD                  |
  | NGINX_REPO_JWT                  |
  | NGINX_USER                      |
  | NMS_HOSTNAME                    |
  | NMS_INSTANCE_GROUP              |
  | NMS_PASSWORD                    |
  | NMS_TOKEN                       |
  | NMS_USER                        |
  | TF_CLOUD_HOSTNAME               |
  | TF_CLOUD_ORGANIZATION           |
  | TF_CLOUD_TOKEN                  |
  | VES_HOSTNAME                    |
  | VES_P12_PASSWORD                |
  | VES_VK8S_CLIENT_CERTIFICATE     |
  | VES_VK8S_CLIENT_KEY             |
  | VES_VK8S_CLUSTER_CA_CERTIFICATE |
  | VES_VK8S_CONTEXT                |
  | VES_VK8S_SERVER                 |

### big-ip

Configuration and Infrastructure management of BIG-IP resources

- Ansible (Configuration)
  - Access Profile Import
  - AS3 Common Declaration
  - Automation Toolchain Installation
  - Create Partitions
  - Provision BIG-IP Modules
  - System BIG-IP Settings
  - Telemetry Streaming Declaration

- Terraform (Configuration)
  - AS3 Application Declarations
  - FAST Application Declarations
  - Application Services in Common

- Terraform (Azure Infrastructure)
  - BIG-IP(s)
  - Availability Set
  - Managed Service Identity Roles(s)
  - Resource Group

- Terraform (AWS Infrastructure)
  - BIG-IP(s)
  - Security Groups
  - Elastic IP

### certs

Certs for F5XC Authentication

- Generated p12 file

### distributed-cloud

Configuration and Infrastructure management of F5XC resources

- Terraform (Configuration)
  - F5XC Application Firewall
  - F5XC Clusters
  - F5XC Endpoints
  - F5XC Health Checks
  - F5XC Http Load-Balancers
  - F5XC Origin Pools
  - F5XC Routes

- Terraform (Infrastructure)
  - F5XC vk8s Site

### godaddy

Configuration management of GoDaddy resources

- Terraform
  - Records Management

### kubernetes

Configuration management of Kubernetes resources

- Terraform (Configuration)
  - NGINX Ingress Controller in Azure Kubernetes Service
  - NGINX IngressLink Controller in Azure Kubernetes Service
  - F5XC Kubernetes Site in Azure Kubernetes Service
  - Argo in Azure Kubernetes Service
  - BIG-IP Container Ingress Services in Azure Kubernetes Service
  - NGINX Unprivileged in F5XC vk8s

- Terraform (Infrastructure)
  - Azure Kubernetes Service(s)
  - Azure Container Regisitry(s)
  - Managed Service Identity Roles(s)
  - Resource Group

### nginx

Configuration and Infrastructure management of NGINX resources

- Ansible (Configuration)
  - NGINX Management Suite Configuration of NGINX

- Terraform (Infrastructure)
  - NGINX(s)
  - Availability Set
  - Resource Group

### services

Configuration of Kubernetes services

- argo
- ingresslink.calalang.net
- kubernetes.calalang.net
- NGINX Management Suite
- nms.calalang.net
- syslog
