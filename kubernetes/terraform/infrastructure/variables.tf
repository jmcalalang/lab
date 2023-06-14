# Azure variables

variable "location" {
  type        = string
  description = "Location of resources"
}
variable "resource_group_name" {
  type        = string
  description = "Resource Group name"
}
variable "existing_subnet_kubernetes_name" {
  type        = string
  description = "Name of existing kubernetes Subnet"
}
variable "existing_subnet_vnet" {
  type        = string
  description = "Name of existing VNET"
}
variable "existing_subnet_resource_group" {
  type        = string
  description = "Name of existing Resource Group"
}
variable "tag_owner" {
  type        = string
  description = "Owner Tag"
}
variable "tag_resource_type" {
  type        = string
  description = "Resource Type"
}
variable "tag_environment" {
  type        = string
  description = "Environment"
}

# Kubernetes variables

variable "aks-instance-count" {
  type        = number
  description = "Number of kubernetes clusters"
}

variable "aks-node-count" {
  type        = number
  description = "Number of nodes in kubernetes clusters"
}

variable "kubernetes_version" {
  type        = string
  description = "Kubernetes version"
}

variable "vm_size" {
  type        = string
  description = "Node instance size"
}