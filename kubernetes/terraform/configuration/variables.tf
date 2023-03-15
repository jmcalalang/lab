# Kubernetes variables

variable "f5xc_site_token" {
  type        = string
  description = "F5XC Site Token"
}


variable "nginx_repo_jwt" {
  type        = string
  description = "NGINX JWT"
}

variable "bigip_aks_username" {
  type        = string
  description = "BIG-IP AKS Username"
}

variable "bigip_aks_password" {
  type        = string
  description = "BIG-IP AKS Password"
}