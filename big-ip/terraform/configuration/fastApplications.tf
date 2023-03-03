# This resource will create and manage FAST applications on BIG-IP from provided JSON declarations.

# FAST declarations
resource "bigip_fast_application" "fast-declarations" {
  for_each = fileset(path.module, "applications/fast/**.json")
  fast_json = file("${path.module}/${each.key}")
}

## LDAP Application
#resource "bigip_fast_application" "ldap-10-0-2-5-fast" {
#  template  = "bigip-fast-templates/ldap"
#  fast_json = file("${path.module}/applications/fast/ldap-10-0-2-5-fast.json")
#}