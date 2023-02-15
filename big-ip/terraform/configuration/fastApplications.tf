# This resource will create and manage FAST applications on BIG-IP from provided JSON declarations.

# LDAP Application
resource "bigip_fast_application" "ldap-10-0-2-5-fast" {
  template  = "bigip-fast-templates/ldap"
  fast_json = file("${path.module}/applications/ldap-10-0-2-5-fast.json")
}