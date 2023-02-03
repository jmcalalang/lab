# NGINX Terraform Variable Definitions

variable "object_count" {
  type        = number
  description = "Number of instance resources"
}
variable "location" {
  type        = string
  description = "Location of resources"
}
variable "resource_group_name" {
  type        = string
  description = "Resource Group name"
}
variable "nginx_username" {
  type        = string
  description = "Environment Variable for NGINX Username"
}
variable "nginx_password" {
  type        = string
  description = "Environment Variable for NGINX Password"
}
variable "tag_owner" {
  type        = string
  description = "Owner Tag"
}

# Existing Subnet Resources

variable "existing_subnet_name" {
  type        = string
  description = "Name of existing Subnet"
}
variable "existing_subnet_vnet" {
  type        = string
  description = "Name of existing VNET"
}
variable "existing_subnet_resource_group" {
  type        = string
  description = "Name of existing Resource Group"
}