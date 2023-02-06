# Jon's Lab

[![Lab Ansible Action](https://github.com/jmcalalang/lab/actions/workflows/main.yaml/badge.svg)](https://github.com/jmcalalang/lab/actions/workflows/main.yaml)

Congratulations you made it to Jon's lab. Below is an outline of the folder structure, in it are the working parts of Jon's lab. This lab is maintained through GitOps (Argo) and CI with GitHub Actions.

## Folder Structure

### github

GitHub Actions for Ansible and Terraform

- GitHub Actions
  - BIG-IP F5 automation toolchain with ansible
  - BIG-IP F5 automation toolchain with terraform
  - GoDaddy with terraform
  - F5xc with terraform
  - NGINX Instance Manager with ansible
  - NGINX with terraform
  
### argo

Agro installation manifest

- Argo
  - argo mainifest for installation into kubernetes

### big-ip

Configuration management for BIG-IP. AS3, DO, TS, and FAST Applications

- Ansible
  - as3 role with templates
    - common objects
    - partition objects
    - gslb objects
  - do role with templates
    - best practices for f5 automation toolchain
  - ts role with templates
    - azure log analytics and pull consumer

- Terraform
  - FAST LDAP Application
  - Virtual Servers in Common

### certs

Certs for F5XC and how to create letsencrypt certs

- f5xc certification for authentication
  - password is a GitHub repository secret
- how to create certs needed for lab resources
  - f5xc certs are auto generated

### cis

CIS configuration for BIG-IP. Managed by Argo

- Argo
  - CIS deployment
  - NGINX ingress (IngressLink)

### distributed-cloud

Configuration for F5XC. Managed by Terraform in Github Action

- Terraform
  - f5xc application firewall
  - f5xc pools (dns,ip,kubernetes)
  - f5xc health checks
  - f5xc http load balancers

### godaddy

GoDaddy configuration. Managed by Terraform in Github Action

- Terraform
  - godaddy zone configuration

### nginx

NGINX configuration done in NIM declarative json templates. Managed by Ansible in Github Action

- Ansible
  - nginx role with nginx instance manager templates

- Terraform
  - NGINX instances(s)
    - Bash script to install NGINX Agent

### nginx-ingress

NGINX ingress configuration

- Argo
  - virtual servers (grpc,https)
  - oidc policy
  - jwt policy
  - nap policy
  - custom zones

### nginx-management-suite

NGINX Management-suite with NIM and ACM. Created with Argo, configured with Ansible (NGINX Folder)

- Argo
  - NMS for NGINX instances
    - NIM (azure-instances)
      - jwt policy
      - api key
      - sensitive uri match
      - proxy_pass
    - ACM (api)

### services

Kubernetes services used for examples. Managed by Argo

- Argo
  - coffee kubernetes service
  - tea kubernetes service
  - http-bin kubernetes service
  - secure-app kubernetes service
  - syslog kubernetes service

### Lab.pdf

PDF of my lab diagram and services in each part