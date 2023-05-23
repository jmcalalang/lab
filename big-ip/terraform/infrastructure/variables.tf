# Shared variables

variable "bigip_ready" {
  type        = string
  description = "BIG-IP Wait time for ready"
}
variable "bigip_runtime_init_package_url" {
  type        = string
  description = "BIG-IP runtime init package url"
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


# Azure variables

variable "azure_location" {
  type        = string
  description = "Location of resources"
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
variable "notification_email" {
  type        = string
  description = "Email for shutdown alert"
}
variable "resource_group_name" {
  type        = string
  description = "Resource Group name"
}

# Azure BIG-IP variables

variable "big-ip-instance-count" {
  type        = number
  description = "Number of big-ip instance resources"
}
variable "big-ip-instance-offer" {
  type        = string
  description = "Offer name for big-ip instance resources"
}
variable "big-ip-instance-size" {
  type        = string
  description = "Size of big-ip instance resources"
}
variable "big-ip-instance-sku" {
  type        = string
  description = "SKU name for big-ip instance resources"
}
variable "big-ip-password" {
  type        = string
  description = "Environment Variable for big-ip Password"
}
variable "big-ip-username" {
  type        = string
  description = "Environment Variable for big-ip Username"
}
variable "big-ip-version" {
  type        = string
  description = "Version of big-ip instance resources"
}

# AWS Variables

variable "allowed_ips" {
  type        = list(any)
  description = "Allowed IP addresses form management access"
}
variable "existing_subnet_az1_management_id" {
  type        = string
  description = "Management subnet availability zone 1"
}
variable "existing_subnet_az1_internal_id" {
  type        = string
  description = "Internal subnet availability zone 1"
}
variable "existing_subnet_az1_external_id" {
  type        = string
  description = "External subnet availability zone 1"
}
variable "existing_subnet_az2_management_id" {
  type        = string
  description = "Management subnet availability zone 2"
}
variable "existing_subnet_az2_internal_id" {
  type        = string
  description = "Internal subnet availability zone 2"
}
variable "existing_subnet_az2_external_id" {
  type        = string
  description = "External subnet availability zone 2"
}
variable "vpc_id" {
  type        = string
  description = "Environment"
}

# AWS BIG-IP variables

variable "big_ip_ami" {
  description = "BIG-IP AMI name to search for"
  type        = string
  default     = "F5 BIGIP-16* PAYG-Best Plus 25Mbps*"
}
variable "big_ip_per_az_count" {
  type        = number
  description = "Count of big-ip's per availability zones"
  validation {
    condition     = var.big_ip_per_az_count >= 0 && var.big_ip_per_az_count <= 4 && floor(var.big_ip_per_az_count) == var.big_ip_per_az_count
    error_message = "Accepted values: 0-4. Multi-Value Route 53 does not accept greater then 8 records"
  }
}
variable "external_secondary_ip_count" {
  type        = number
  description = "Additional secondary addresses for external interface"
}
variable "internal_secondary_ip_count" {
  type        = number
  description = "Additional secondary addresses for internal interface"
}
variable "instance_type" {
  type        = string
  description = "AWS instance type"
}
variable "key_name" {
  type        = string
  description = "AWS key name for EC2"
}