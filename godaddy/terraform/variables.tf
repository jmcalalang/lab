# GoDaddy Terraform Variable Definitions


variable "http-lb-kubernetes-ves-hostname" {
  type        = string
  description = "Kubernetes http load balancer ves hostname"
}
variable "http-lb-big-ip-ves-hostname" {
  type        = string
  description = "BIG-IP http load balancer ves hostname"
}
variable "http-lb-nginx-ves-hostname" {
  type        = string
  description = "NGINX http load balancer ves hostname"
}
variable "tfe_token" {
  type        = string
  description = "Terraform cloud token"
}
variable "ttl" {
  type        = number
  description = "DNS time to live"
}
variable "record-type-cname" {
  type        = string
  description = "DNS record type"
}