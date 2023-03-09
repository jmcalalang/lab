# Azure variables

variable "location" {
  type        = string
  description = "Location of resources"
}
variable "resource_group_name" {
  type        = string
  description = "Resource Group name"
}
variable "existing_subnet_management_name" {
  type        = string
  description = "Name of existing management Subnet"
}
variable "existing_subnet_internal_name" {
  type        = string
  description = "Name of existing internal Subnet"
}
variable "existing_subnet_external_name" {
  type        = string
  description = "Name of existing external Subnet"
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

# BIG-IP variables

variable "big-ip-username" {
  type        = string
  description = "Environment Variable for big-ip Username"
}
variable "big-ip-password" {
  type        = string
  description = "Environment Variable for big-ip Password"
}
variable "big-ip-instance-offer" {
  type        = string
  description = "Offer name for big-ip instance resources"
}
variable "big-ip-instance-sku" {
  type        = string
  description = "SKU name for big-ip instance resources"
}
variable "big-ip-version" {
  type        = string
  description = "Version of big-ip instance resources"
}
variable "big-ip-instance-count" {
  type        = number
  description = "Number of big-ip instance resources"
}
variable "big-ip-instance-size" {
  type        = string
  description = "Size of big-ip instance resources"
}
variable "bigip_runtime_init_package_url" {
  type        = string
  description = "BIG-IP runtime init package url"
}
variable "bigip_ready" {
  type        = string
  description = "BIG-IP Wait time for ready"
}