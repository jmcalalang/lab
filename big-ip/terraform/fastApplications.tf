## This resource will create and manage FAST applications on BIG-IP from provided JSON declaration.

resource "bigip_fast_application" "ldap_10_0_2_15_fast" {
  template  = "bigip-fast-templates/ldap"
  fast_json = ("${path.module}/applications/ldap_10_0_2_15_fast.json")
}