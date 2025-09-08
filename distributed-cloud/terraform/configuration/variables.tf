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
variable "jwk-calalang-net" {
  type        = string
  description = "JWK for validation"
}
variable "wildcard-calalang-net-certificate" {
  type        = string
  description = "Certificate base64 encoded"
  sensitive   = true
}
variable "wildcard-calalang-net-key" {
  type        = string
  description = "Key base64 encoded"
  sensitive   = true
}