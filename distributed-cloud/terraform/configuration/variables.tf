# F5XC Terraform Variable Definitions

# Shared Variables
variable "namespace" {
  type        = string
  description = "Namespace for deployed objects in F5XC"
}
variable "label-owner" {
  type        = string
  description = "Owner Tag"
}
variable "label-resource-type" {
  type        = string
  description = "Resource Type"
}
variable "label-environment" {
  type        = string
  description = "Environment"
}

# Resource Variables

variable "domain" {
  type        = string
  description = "domain"
}
variable "jwk_calalang_net" {
  type        = string
  description = "JWK for validation"
}
variable "wildcard_calalang_net_certificate" {
  type        = string
  description = "Certificate base64 encoded"
  sensitive   = true
}
variable "wildcard_calalang_net_key" {
  type        = string
  description = "Key base64 encoded"
  sensitive   = true
}