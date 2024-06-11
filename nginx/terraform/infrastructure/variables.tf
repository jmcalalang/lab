# Azure variables

variable "location" {
  type        = string
  description = "Location of resources"
}
variable "resource_group_name" {
  type        = string
  description = "Resource Group name"
}
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
variable "notification_email" {
  type        = string
  description = "Email for shutdown alert"
}

# NGINX variables

variable "nginx_one_dataplane_key" {
  type        = string
  description = "NGINX ONE Dataplane Key"
}
variable "nginx-instance-offer" {
  type        = string
  description = "Offer name for NGINX instance resources"
}
variable "nginx-instance-sku" {
  type        = string
  description = "SKU name for NGINX instance resources"
}
variable "nginx-instance-version" {
  type        = string
  description = "Version of NGINX instance resources"
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
variable "nginx-api-gw-version" {
  type        = string
  description = "Version of NGINX API GW resources"
}
variable "nginx-api-gw-count" {
  type        = number
  description = "Number of NGINX API GW resources"
}
variable "nginx_username" {
  type        = string
  description = "Environment Variable for NGINX Username"
}
variable "nginx_password" {
  type        = string
  description = "Environment Variable for NGINX Password"
}
variable "nms-hostname" {
  type        = string
  description = "NGINX Management Suite Hostname"
}