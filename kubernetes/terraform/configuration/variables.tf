# Kubernetes variables

# ArgoCD Values
variable "argo-chart-version" {
  type        = string
  description = "ArgoCD Chart Version"
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


# Nginx Ingress Controller Values
variable "nginx-ingress-controller-chart-version" {
  type        = string
  description = "NGINX Ingress Controller Chart Version"
}
variable "nginx-ingress-controller-image" {
  type        = string
  description = "NGINX Ingress Controller Image"
}
variable "nginx_repo_jwt" {
  type        = string
  description = "NGINX JWT"
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