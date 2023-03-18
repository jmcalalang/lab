# F5 Lab

Congratulations you've made it to Jon's F5 lab. This lab environment is used daily to demonstrate various F5 products (F5XC, BIG-IP, and NGINX).

All the components of this lab are maintained through GitOps (Argo) and CI with GitHub Actions.

|                                                           **Products**                                                          |                                                           **Tools**                                                          |                                                                                      **Code**                                                                                     |
|:-------------------------------------------------------------------------------------------------------------------------------:|:----------------------------------------------------------------------------------------------------------------------------:|:---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------:|
| ![F5 Badge](https://img.shields.io/badge/F5-E4002B?logo=f5&logoColor=fff&style=plastic)                                         | ![Terraform Badge](https://img.shields.io/badge/Terraform-7B42BC?logo=terraform&logoColor=fff&style=plastic)                 | [![Lab Pipeline](https://github.com/jmcalalang/lab/actions/workflows/main.yaml/badge.svg?event=deployment_status)](https://github.com/jmcalalang/lab/actions/workflows/main.yaml) |
| ![NGINX Badge](https://img.shields.io/badge/NGINX-009639?logo=nginx&logoColor=fff&style=plastic)                                | ![Ansible Badge](https://img.shields.io/badge/Ansible-E00?logo=ansible&logoColor=fff&style=plastic)                          | [![Lab Pipeline](https://github.com/jmcalalang/lab/actions/workflows/main.yaml/badge.svg?event=issues)](https://github.com/jmcalalang/lab/actions/workflows/main.yaml)            |
| ![Microsoft Azure Badge](https://img.shields.io/badge/Microsoft%20Azure-0078D4?logo=microsoftazure&logoColor=fff&style=plastic) | ![GitHub Actions Badge](https://img.shields.io/badge/GitHub%20Actions-2088FF?logo=githubactions&logoColor=fff&style=plastic) | [![Lab Pipeline](https://github.com/jmcalalang/lab/actions/workflows/main.yaml/badge.svg?event=pull_request)](https://github.com/jmcalalang/lab/actions/workflows/main.yaml)      |
| ![Kubernetes Badge](https://img.shields.io/badge/Kubernetes-326CE5?logo=kubernetes&logoColor=fff&style=plastic)                 | ![Argo Badge](https://img.shields.io/badge/Argo-EF7B4D?logo=argo&logoColor=fff&style=plastic)                                |                                                                                                                                                                                   |
| ![GoDaddy Badge](https://img.shields.io/badge/GoDaddy-1BDBDB?logo=godaddy&logoColor=000&style=plastic)                          |                                                                                                                              |                                                                                                                                                                                   |

## Environment

![image](lab.png)

## Folder Structure

### github

GitHub Actions for Ansible and Terraform

- GitHub Actions
  - F5XC
    - Terraform
  - BIG-IP
    - Terraform
    - Ansible
  - GoDaddy
    - Terraform
  - NGINX / NGINX Management System
    - Terraform
    - Ansible
  - Kubernetes
    - Terraform
  - Argo
    - Terraform

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

- Terraform (Infrastructure)
  - Create BIG-IP(s)
  - Create Availability Set
  - Create RBAC Roles
  - Create Resource Group

### certs

Certs for F5XC Authentication

- Generated p12 file

### distributed-cloud

Configuration management of F5XC resources

- Terraform (Infrastructure)
  - F5XC Application Firewall
  - F5XC Origin Pools
  - F5XC Health Checks
  - F5XC Http Load-Balancers

### godaddy

Configuration management of GoDaddy resources

- Terraform
  - Records Management

### kubernetes

Configuration management of Kubernetes resources

- Terraform (Configuration)
  - Install NGINX Ingress Controller
  - Install NGINX IngressLink Controller
  - Install F5XC Kubernetes Site
  - Install Argo

- Terraform (Infrastructure)
  - Create Azure Kubernetes Service
  - Create Azure Container Regisitry
  - Create RBAC Roles
  - Create Resource Group

### nginx

Configuration and Infrastructure management of NGINX resources

- Ansible (Configuration)
  - NGINX Management Suite Configuration of NGINX

- Terraform (Infrastructure)
  - Create NGINX(s)
  - Create Availability Set
  - Create Resource Group

### services

Configuration of Kubernetes services

- Argo
- Container Ingress Services (BIG-IP)
- Google Online Boutique
- ingresslink.calalang.net
- kubernetes.calalang.net
- NGINX Management Suite
- NGINX.org
- NGINX Plus
- nms.calalang.net
- Syslog