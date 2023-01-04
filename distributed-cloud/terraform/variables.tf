# F5XC Terraform Variable Definitions

variable "namespace" {
  type        = string
  description = "Namespace for deployed objects in F5XC"
}
variable "owner" {
  type        = string
  description = "Creator of resource"
}