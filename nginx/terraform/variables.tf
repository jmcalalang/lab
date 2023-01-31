# NGINX Terraform Variable Definitions

variable "count" {
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
variable "subnet_id" {
  type        = string
  description = "Subnet Attachment"
}