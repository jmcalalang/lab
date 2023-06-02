## F5XC Terraform Variable Definitions

variable "namespace" {
  type        = string
  description = "Namespace for deployed objects in F5XC"
}
variable "label-email" {
  type        = string
  description = "Owner email"
}
variable "label-owner" {
  type        = string
  description = "Owner name"
}
variable "label-resource-type" {
  type        = string
  description = "Resource Type"
}
variable "label-environment" {
  type        = string
  description = "Environment"
}

# F5 Distributed Cloud Virtual Kubernetes Cluster
variable "vk8s-name" {
  type        = string
  description = "Name of vk8s cluster"
}

# F5 Distributed Cloud Azure Site
variable "f5xc-azure-site-latitude" {
  type        = number
  description = "Location of resources"
}
variable "f5xc-azure-site-longitude" {
  type        = number
  description = "Location of resources"
}
variable "f5xc-azure-site-resource-group" {
  type        = string
  description = "Created resource group name"
}
variable "f5xc-azure-site-offer" {
  type        = string
  description = "Offer name for f5xc azure sites"
}
variable "f5xc-cloud-credential" {
  type        = string
  description = "Offer name for f5xc azure sites"
}
variable "location" {
  type        = string
  description = "Location of resources"
}
variable "existing-vnet-resource-group" {
  type        = string
  description = "Existing resource group name"
}
variable "existing-vnet" {
  type        = string
  description = "Existing vnet name"
}
variable "existing-vnet-subnet" {
  type        = string
  description = "Existing vnet subnet name"
}