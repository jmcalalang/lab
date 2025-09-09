# This resource will create and manage imperative applications on BIG-IP.

# Virtual server apm-calalang-net
resource "bigip_ltm_virtual_server" "virtual-apm-calalang-net" {
  name            = "/Common/https-terraform"
  client_profiles = [bigip_ltm_profile_client_ssl.virtual-apm-calalang-net-client-ssl-profile.name]
  destination     = "10.0.2.7"
  description     = "apm.calalang.net"
  #  irules                     = ["/Common/Shared/BIG-IP_Maintenance_Page_rule"]
  pool                       = bigip_ltm_pool.pool-apm-calalang-net-terraform.name
  port                       = 443
  profiles                   = ["/Common/f5-tcp-progressive", "/Common/http", "/Common/calalang-oidc", "/Common/calalang-oidc-connectivity-profile", "/Common/ppp", "/Common/vdi"]
  server_profiles            = ["/Common/serverssl-insecure-compatible"]
  source_address_translation = "automap"
  vlans                      = ["/Common/external"]
  vlans_enabled              = "true"
}

resource "bigip_ltm_profile_client_ssl" "virtual-apm-calalang-net-client-ssl-profile" {
  name = "/Common/virtual-apm-calalang-net-client-ssl-profile"
  cert_key_chain {
    cert = "/Common/Shared/calalangTLSCert.crt"
  }
  defaults_from = "/Common/clientssl"
  authenticate  = "always"
  ciphers       = "DEFAULT"
}

resource "bigip_ltm_pool" "pool-apm-calalang-net-terraform" {
  name                   = "/Common/pool-apm-calalang-net-terraform"
  allow_snat             = "yes"
  allow_nat              = "yes"
  load_balancing_mode    = "round-robin"
  minimum_active_members = 1
  monitors               = ["/Common/tcp"]
}

resource "bigip_ltm_pool_attachment" "apm-calalang-net-pool-attachment" {
  for_each = toset([bigip_ltm_node.node-nginx-com-terraform.name])
  node     = "${each.key}:443"
  pool     = bigip_ltm_pool.pool-apm-calalang-net-terraform.name
}

resource "bigip_ltm_node" "node-nginx-com-terraform" {
  name    = "/Common/node-nginx-com-terraform"
  address = "nginx.com"
  fqdn {
    address_family = "ipv4"
    interval       = "3000"
  }
}