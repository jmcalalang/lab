# Jon's Lab

[![Lab Ansible Action](https://github.com/jmcalalang/lab/actions/workflows/main.yaml/badge.svg)](https://github.com/jmcalalang/lab/actions/workflows/main.yaml)

Congratulations you made it to Jon's lab. Below is an outline of the folder structure, in it are the working parts of Jon's lab. This lab is maintained through GitOps (Argo) and CI with GitHub Actions.

## Folder Structure

### github

GitHub Actions for Ansible and Terraform

- github action for BIG-IP F5 automation toolchain with ansible
- github action for F5XC with terraform
  
### argo

Agro installation manifest

- argo mainifest for installation into kubernetes

### big-ip

Ansible configuration management for BIG-IP. AS3, DO, and TS. Managed by Ansible in Github Action

- default main for Ansible Roles variables
- as3 role with templates
  - common objects
  - partition objects
  - gslb objects
- do role with templates
  - best practices for f5 automation toolchain
- ts role with templates
  - azure log analytics and pull consumer

### certs

Certs for F5XC and how to create letsencrypt certs

- f5xc certification for authentication
  - password is a GitHub repository secret
- how to create certs needed for lab resources

### cis

CIS configuration for BIG-IP. Managed by Argo

- CIS deployment
- virtual server with tls for NGINX ingress (IngressLink)

### distributed-cloud

Terraform configuration for F5XC. Managed by Terraform in Github Action

- f5xc application firewall
- f5xc pools (dns,ip,kubernetes)
- f5xc health checks
  
### f5-automation-toolchain

Automation toolchain templates that Ansible uses for BIG-IP. Managed by Ansible in Github Action

- as3 templates used by ansible
- do templates used by ansible
- ts templates used by ansible

### nginx-ingress

NGINX ingress configuration. Managed by Argo

- virtual servers (grpc,https)
- oidc policy
- nap policy

### nginx-service-mesh

NGINX Service Mesh installation scratch

- installation scratch

### openshift

Openshift configuration examples

- installation scratch/examples

### services

Kubernetes services used for examples. Managed by Argo

- coffee kubernetes service
- tea kubernetes service
- http-bin kubernetes service
  - oidc policy
- secure-app kubernetes service
- syslog kubernetes service

### Lab.pdf

PDF of my lab diagram and services in each part