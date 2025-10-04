# Kubernetes variables

# ArgoCD Values
variable "argo-chart-version" {
  type        = string
  description = "ArgoCD Chart Version"
}
variable "calalang_oidc_app_value" {
  type        = string
  description = "Calalang OIDC App Value"
}

# BIG-IP Container Ingress Services Values
variable "big-ip-cis-chart-version" {
  type        = string
  description = "BIG-IP Container Ingress Services Chart Version"
}
variable "big-ip-cis-image" {
  type        = string
  description = "BIG-IP Container Ingress Services Image"
}
variable "big-ip-ltm-management-address" {
  type        = string
  description = "BIG-IP Container Ingress Services LTM Target"
}
variable "big-ip-gtm-management-address" {
  type        = string
  description = "BIG-IP Container Ingress Services GTM Target"
}
variable "bigip_aks_username" {
  type        = string
  description = "BIG-IP AKS Username"
}
variable "bigip_aks_password" {
  type        = string
  description = "BIG-IP AKS Password"
}
variable "bigip_aks_partition" {
  type        = string
  description = "BIG-IP AKS Partition"
}

# Nginx Ingress Controller Values
variable "nginx-ingress-controller-chart-version" {
  type        = string
  description = "NGINX Ingress Controller Chart Version"
}
# kubectl create secret generic license-token --from-file=license.jwt=<path-to-your-jwt> --type=nginx.com/license -n <your-namespace>
variable "nginx_license_jwt_base64" {
  type        = string
  description = "NGINX License JWT Base64"
}
# This data is the dockerconfigjson of a manually created secret 
# kubectl create secret \
# docker-registry regcred \
# --docker-server=private-registry.nginx.com \
# --docker-username= "clear nginx jwt" \
# --docker-password=none
variable "nginx_regcred_data" {
  type        = string
  description = "NGINX Generated regcred data"
}
# vk8s Terraform Variable Values
variable "f5xc_site_token" {
  type        = string
  description = "F5XC Site Token"
}
variable "namespace" {
  type        = string
  description = "Namespace for deployed objects in F5XC"
}
variable "owner" {
  type        = string
  description = "Creator of resource"
}
variable "nginx-unprivileged-version" {
  type        = string
  description = "Version of nginx unprivileged"
}
variable "ves_vk8s_context" {
  type        = string
  description = "vk8s context"
}
variable "ves_vk8s_client_certificate" {
  type        = string
  description = "Base64 of vk8s client certificate"
}
variable "ves_vk8s_client_key" {
  type        = string
  description = "Base64 of vk8s client key"
}
variable "ves_vk8s_cluster_ca_certificate" {
  type        = string
  description = "Base64 of vk8s cluster ca certificate"
}
variable "ves_vk8s_server" {
  type        = string
  description = "vk8s server"
}
