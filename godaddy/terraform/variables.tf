# GoDaddy Terraform Variable Definitions

variable "http-lb-discovery-ves-hostname" {
  type        = string
  description = "Discovery http load balancer ves hostname"
}
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
variable "ttl" {
  type        = number
  description = "DNS time to live"
}
variable "record-type-cname" {
  type        = string
  description = "DNS record type"
}
variable "record-type-txt" {
  type        = string
  description = "DNS record type"
}