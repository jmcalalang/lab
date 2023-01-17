# This resource will create and manage FAST applications on BIG-IP from provided JSON declaration.

resource "bigip_fast_application" "ldap-10-0-2-15-fast" {
  template  = "bigip-fast-templates/ldap"
  fast_json = file("${path.module}/applications/ldap-10-0-2-15-fast.json")
}