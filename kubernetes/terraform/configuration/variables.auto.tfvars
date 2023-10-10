# ArgoCD Values
argo-chart-version = "5.46.7"

# BIG-IP Container Ingress Services Values
big-ip-cis-chart-version      = "0.0.24"
big-ip-cis-image              = "2.12.0"
big-ip-ltm-management-address = "10.0.1.4"
big-ip-gtm-management-address = "10.0.1.4"
bigip_aks_partition           = "calalang-aks-cluster"

# Nginx Ingress Controller Values
nginx-ingress-controller-chart-version = "0.17.1"
nginx-ingress-controller-image         = "3.1.1"

# vk8s Terraform Variable Values

namespace                  = "j-calalang"
owner                      = "j-calalang"
nginx-unprivileged-version = "v4.1"