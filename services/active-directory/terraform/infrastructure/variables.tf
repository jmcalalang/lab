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

# Active Directory variables

variable "active-directory-instance-offer" {
  type        = string
  description = "Offer name for Active Directory instance resources"
}
variable "active-directory-instance-publisher" {
  type        = string
  description = "Publisher name for Active Directory instance resources"
}
variable "active-directory-instance-sku" {
  type        = string
  description = "SKU name for Active Directory instance resources"
}
variable "active-directory-instance-version" {
  type        = string
  description = "Version of Active Directory instance resources"
}
variable "active-directory-instance-count" {
  type        = number
  description = "Number of Active Directory instance resources"
}
variable "active-directory-username" {
  type        = string
  description = "Environment Variable for Active Directory Username"
}
variable "active-directory-password" {
  type        = string
  description = "Environment Variable for Active Directory Password"
}
