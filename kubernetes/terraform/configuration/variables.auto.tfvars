# ArgoCD Values
# Versions: https://github.com/argoproj/argo-helm
argo-chart-version = "8.2.5"

# BIG-IP Container Ingress Services Values
# Versions: https://github.com/F5Networks/k8s-bigip-ctlr/tree/master/helm-charts/f5-bigip-ctlr
big-ip-cis-chart-version      = "0.0.35"
big-ip-cis-image              = "2.20.1"
big-ip-ltm-management-address = "10.0.1.4"
big-ip-gtm-management-address = "10.0.1.4"
bigip_aks_partition           = "calalang-aks-cluster"

# Nginx Ingress Controller Values
# Versions: https://github.com/nginxinc/helm-charts/tree/master/stable
nginx-ingress-controller-chart-version = "2.2.2"

# vk8s Terraform Variable Values
namespace                  = "j-calalang"
owner                      = "j-calalang"
nginx-unprivileged-version = "alpine3.21-perl"
