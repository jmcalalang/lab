# This resource will create and manage imperative applications on BIG-IP.

# Virtual server apm-calalang-net
resource "bigip_ltm_virtual_server" "virtual-apm-calalang-net" {
  name                       = "/Common/https-terraform"
  destination                = "10.0.2.7"
  description                = "apm.calalang.net"
  port                       = 443
  client_profiles            = ["/Common/clientssl"]
  server_profiles            = ["/Common/serverssl-insecure-compatible"]
  source_address_translation = "automap"
  vlans                      = ["/Common/external"]
  vlans_enabled              = "true"
  profiles                   = ["/Common/f5-tcp-progressive", "/Common/http", "/Common/calalang-oidc"]
  pool                       = bigip_ltm_pool.pool-apm-calalang-net-terraform.name
}
resource "bigip_ltm_pool" "pool-apm-calalang-net-terraform" {
  name                   = "/Common/pool-apm-calalang-net-terraform"
  load_balancing_mode    = "round-robin"
  minimum_active_members = 1
  monitors               = ["/Common/tcp"]
  allow_snat             = "yes"
  allow_nat              = "yes"
}
resource "bigip_ltm_pool_attachment" "apm-calalang-net-pool-attachment" {
  for_each = toset([bigip_ltm_node.node-nginx-com-terraform.name])
  pool     = bigip_ltm_pool.pool-apm-calalang-net-terraform.name
  node     = "${each.key}:443"
}
resource "bigip_ltm_node" "node-nginx-com-terraform" {
  name    = "/Common/node-nginx-com-terraform"
  address = "nginx.com"
  fqdn {
    address_family = "ipv4"
    interval       = "3000"
  }
}