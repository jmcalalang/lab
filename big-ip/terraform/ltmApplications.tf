# A Virtual server with separate client and server profiles
resource "bigip_ltm_virtual_server" "https_10_0_2_51_terraform" {
  name                       = "/Common/https_10_0_2_51_terraform"
  destination                = "10.0.2.51"
  description                = "OIDC Forwarding Virtual Server"
  port                       = 443
  client_profiles            = ["/Common/clientssl"]
  source_address_translation = "automap"
  irules                     = ["OIDC_v2v_local_rule"]
  vlans                      = "true"
  vlans_enabled              = ["/Common/external"]
  profiles                   = ["/Common/f5-tcp-progressive", "/Common/http"]
}