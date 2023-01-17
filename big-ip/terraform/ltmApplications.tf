# A Virtual server with separate client and server profiles
resource "bigip_ltm_virtual_server" "https-10-0-2-51-terraform" {
  name                       = "/Common/https-10-0-2-51-terraform"
  destination                = "10.0.2.51"
  description                = "OIDC Forwarding Virtual Server"
  port                       = 443
  client_profiles            = ["/Common/clientssl"]
  source_address_translation = "automap"
  irules { name = [bigip_ltm_irule.forward-nginxCalalangNet-vs.name] }
  vlans         = ["/Common/external"]
  vlans_enabled = "true"
  profiles      = ["/Common/f5-tcp-progressive", "/Common/http"]
}