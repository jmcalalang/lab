# This resource will create and manage imperative applications on BIG-IP.

# Virtual server https-10-0-2-7-terraform
resource "bigip_ltm_virtual_server" "apm-calalang-net" {
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
  pool                       = bigip_ltm_pool.pool-ip-nginx-azure-instances.name
}
resource "bigip_ltm_pool" "pool-ip-nginx-azure-instances" {
  name                   = "/Common/pool-ip-nginx-azure-instances-terraform"
  load_balancing_mode    = "round-robin"
  minimum_active_members = 1
  monitors               = ["/Common/http"]
  allow_snat             = "yes"
  allow_nat              = "yes"
}
resource "bigip_ltm_pool_attachment" "apm-calalang-net-pool-attachment" {
  for_each = toset([bigip_ltm_node.node-nginx-org-terraform.name])
  pool     = bigip_ltm_pool.pool-ip-nginx-azure-instances.name
  node     = "${each.key}:80"
}
resource "bigip_ltm_node" "node-nginx-org-terraform" {
  name    = "/Common/node-nginx-org-terraform"
  address = "nginx.org"
  fqdn {
    address_family = "ipv4"
    interval       = "3000"
  }
}