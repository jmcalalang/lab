# NGINX Terraform Variable Definitions

variable "nginx-instance-offer" {
  type        = string
  description = "Offer name for NGINX instance resources"
}
variable "nginx-instance-sku" {
  type        = string
  description = "SKU name for NGINX instance resources"
}
variable "nginx-instance-count" {
  type        = number
  description = "Number of NGINX instance resources"
}
variable "nginx-api-gw-offer" {
  type        = string
  description = "Offer name for NGINX API GW resources"
}
variable "nginx-api-gw-sku" {
  type        = string
  description = "SKU name for NGINX API GW resources"
}
variable "nginx-api-gw-count" {
  type        = number
  description = "Number of NGINX API GW resources"
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

variable "existing_internal_subnet_name" {
  type        = string
  description = "Name of existing internal Subnet"
}
variable "existing_external_subnet_name" {
  type        = string
  description = "Name of existing external Subnet"
}
variable "existing_mgmt_subnet_name" {
  type        = string
  description = "Name of existing management Subnet"
}
variable "existing_subnet_vnet" {
  type        = string
  description = "Name of existing VNET"
}
variable "existing_subnet_resource_group" {
  type        = string
  description = "Name of existing Resource Group"
}