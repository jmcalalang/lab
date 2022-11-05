# F5XC Variables

variable "namespace" {
  type        = string
  description = "Namespace for deployed objects in F5XC"
  default     = ""
}
variable "owner" {
  type        = string
  description = "Creator of resource"
  default     = ""
}