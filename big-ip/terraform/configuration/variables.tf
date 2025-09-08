# BIG-IP variables

variable "ad_service_ldap_password" {
  type        = string
  description = "Password for the LDAP Service Account"
}

variable "ARM_SUBSCRIPTION_ID" {
  type        = string
  description = "Azure subscription ID"
}

variable "as3-version" {
  type        = string
  description = "AS3 Schema Version Number"
}

variable "wildcard_calalang_net_certificate" {
  type        = string
  description = "SSL Certificate for calalang.net"
  sensitive   = true
}

variable "wildcard_calalang_net_key" {
  type        = string
  description = "SSL Key for calalang.net"
  sensitive   = true
}