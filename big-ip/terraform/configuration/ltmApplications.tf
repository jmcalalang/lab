# This resource will create and manage imperative applications on BIG-IP.

# Virtual server https-10-0-2-7-terraform
resource "bigip_ltm_virtual_server" "https-10-0-2-7-terraform" {
  name                       = "/Common/https-10-0-2-7-terraform"
  destination                = "10.0.2.7"
  description                = "apm.calalang.net"
  port                       = 443
  client_profiles            = ["/Common/clientssl"]
  server_profiles            = ["/Common/serverssl-insecure-compatible"]
  source_address_translation = "automap"
  vlans                      = ["/Common/external"]
  vlans_enabled              = "true"
  profiles                   = ["/Common/f5-tcp-progressive", "/Common/http"]
  pool                       = bigip_ltm_pool.pool-ip-nginx-azure-instances-terraform.name
}
resource "bigip_ltm_pool" "pool-ip-nginx-azure-instances-terraform" {
  name                   = "/Common/pool-ip-nginx-azure-instances-terraform"
  load_balancing_mode    = "round-robin"
  minimum_active_members = 1
  monitors               = ["/Common/http"]
  allow_snat             = "yes"
  allow_nat              = "yes"
}
resource "bigip_ltm_pool_attachment" "attach_node" {
  for_each = toset([bigip_ltm_node.node-10-0-3-4-terraform.name])
  pool     = bigip_ltm_pool.pool-ip-nginx-azure-instances-terraform.name
  node     = "${each.key}:80"
}
resource "bigip_ltm_node" "node-10-0-3-4-terraform" {
  name    = "/Common/node-10-0-3-4-terraform"
  address = "10.0.3.4"
}