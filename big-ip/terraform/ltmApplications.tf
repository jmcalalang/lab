# Virtual server https-10-0-2-12-terraform
resource "bigip_ltm_virtual_server" "https-10-0-2-12-terraform" {
  name                       = "/Common/https-10-0-2-12-terraform"
  destination                = "10.0.2.12"
  description                = "apm.calalang.net"
  port                       = 443
  client_profiles            = ["/Common/clientssl"]
  source_address_translation = "automap"
  vlans                      = ["/Common/external"]
  vlans_enabled              = "true"
  profiles                   = ["/Common/f5-tcp-progressive", "/Common/http", "/Common/calalang-oidc"]
  pool                       = bigip_ltm_pool.pool-nginx-azure-instances-terraform.name
}
resource "bigip_ltm_monitor" "monitor-nginx-azure-instances-terraform" {
  name   = "/Common/monitor-nginx-azure-instances-terraform"
  parent = "/Common/http"
}
resource "bigip_ltm_pool" "pool-nginx-azure-instances-terraform" {
  name                   = "/Common/pool-nginx-azure-instances-terraform"
  load_balancing_mode    = "round-robin"
  minimum_active_members = 1
  monitors               = [bigip_ltm_monitor.monitor.name]
  allow_snat             = "yes"
  allow_nat              = "yes"
}
resource "bigip_ltm_pool_attachment" "attach_node" {
  for_each = toset([bigip_ltm_node.node-10-0-3-5-terraform.name])
  pool     = bigip_ltm_pool.pool-nginx-azure-instances-terraform.name
  node     = "${each.key}:80"
}
resource "bigip_ltm_node" "node-10-0-3-5-terraform" {
  name    = "/Common/node-10-0-3-5-terraform"
  address = "10.0.3.5"
}