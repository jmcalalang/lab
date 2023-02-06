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
}