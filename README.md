Lab
===

[![Lab Ansible Action](https://github.com/jmcalalang/lab/actions/workflows/main.yml/badge.svg)](https://github.com/jmcalalang/lab/actions/workflows/main.yml)

Core-RG
  - Networking
  - Container Registry
  - Log Analytics and Workspaces
  - Azure Key-Vault
  - Sec Groups
  - 1 Windows Domain Controller

BIGIP-RG
  - 1 BIG-IP
    - Solutions:
      - WAF (AS3) (Volterra, Landing Zone)
      - APM (Volterra, Landing Zone)
      - LTM (AS3) (Volterra, Landing Zone)
      - CIS / IngressLink (VirtualServer, Transport, IPAM) (Volterra, Landing Zone, NGINX Ingress)
      - Telemetry Streaming / App Insights (Landing Zone)
      - OIDC (Volterra, Landing Zone)
      - GTM (AS3) (Datacenter, Servers, Pools, WIPs)

NGINX-RG
  - 2 NGINX (1vcpu 1GB)(managed by Controller)
  - 1 NGINX (1vcpu 1GB)(managed by NIM)
  - 1 Controller
  - 1 NIM
    - Solutions:
      - Controller
      - NIM
      - Load Balancing
      - API Management
      - OIDC
      - JWT Validation
      - Custom Status Zones
      - Custom keyval variables

AKS-RG
  - 2 Nodes
    - Solutions:
      - NGINX Ingress (Landing Zone, Volterra)
      - NGINX Ingress Security (Landing Zone, Volterra)
      - NGINX Service Mesh (Landing Zone, Volterra, NGINX Ingress)
      - Volterra Site for Kubernetes
      - Argo CD
      - coffee
      - http-bin
      - secure-app
      - syslog
      - tea

Volterra-RG (Phase 2)
  - 1 CE (Stack) (Landing Zone, Cloud Credentials)
    - Solutions:
      - WAF to NGINX
      - HTTPS to APM
      - WAF to Kubernetes w/Service Discovery
      - Bound to Azure Container Registry

Azure Active Directory
LetsEncrypt
Godaddy Domain