# This resource will create and manage FAST applications on BIG-IP from provided JSON declarations.

# LDAP Application
resource "bigip_fast_application" "ldap-10-0-2-5-fast" {
  for_each        = fileset(path.module, "applications/fast/ldap/**.tpl")
  fast_json       = templatefile("${path.module}/${each.key}", { monitor_passphrase = var.ad_service_ldap_password })
  # template  = "bigip-fast-templates/ldap"
}