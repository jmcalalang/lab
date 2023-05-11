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