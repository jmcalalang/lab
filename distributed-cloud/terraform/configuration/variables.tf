# F5XC Terraform Variable Definitions

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
variable "ves_vk8s_host" {
  type        = string
  description = "vk8s host"
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