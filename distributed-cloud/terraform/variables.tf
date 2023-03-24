# F5XC Terraform Variable Definitions

variable "vk8s-name" {
  type        = string
  description = "Name of vk8s cluster"
}
variable "namespace" {
  type        = string
  description = "Namespace for deployed objects in F5XC"
}
variable "owner" {
  type        = string
  description = "Creator of resource"
}