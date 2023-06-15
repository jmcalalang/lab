# Shared variables

variable "allowed_ips" {
  type        = list(any)
  description = "Allowed IP addresses form management access"
}
variable "allowed_github_ips" {
  type        = list(any)
  description = "Allowed IP addresses form management access"
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

# AWS Variables

variable "aws_location" {
  type        = string
  description = "Location of resources"
}

# Azure variables

variable "azure_location" {
  type        = string
  description = "Location of resources"
}
variable "resource_group_name" {
  type        = string
  description = "Resource Group name"
}