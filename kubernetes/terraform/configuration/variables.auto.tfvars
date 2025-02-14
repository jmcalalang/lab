# ArgoCD Values
# Versions: https://github.com/argoproj/argo-helm
argo-chart-version = "5.49.0"

# BIG-IP Container Ingress Services Values
# Versions: https://github.com/F5Networks/k8s-bigip-ctlr/tree/master/helm-charts/f5-bigip-ctlr
big-ip-cis-chart-version      = "0.0.26"
big-ip-cis-image              = "2.14.0"
big-ip-ltm-management-address = "10.0.1.4"
big-ip-gtm-management-address = "10.0.1.4"
bigip_aks_partition           = "calalang-aks-cluster"

# Nginx Ingress Controller Values
# Versions: https://github.com/nginxinc/kubernetes-ingress/tree/main/charts/nginx-ingress
nginx-ingress-controller-chart-version = "0.17.1"
nginx-ingress-controller-image         = "3.1.1"

# vk8s Terraform Variable Values
namespace                  = "j-calalang"
owner                      = "j-calalang"
nginx-unprivileged-version = "mainline-alpine-perl"