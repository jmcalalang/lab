# Variables

# F5XC Environment

variable "namespace" {
  type    = list(string)
  default = ["j-calalang"]
}

variable "owner" {
  type    = list(string)
  default = ["j.calalang@f5.com"]
}