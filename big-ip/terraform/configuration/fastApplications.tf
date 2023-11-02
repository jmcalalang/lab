# This resource will create and manage FAST applications on BIG-IP from provided JSON declarations.

# HTTP Application
resource "bigip_fast_application" "http-manifest" {
  for_each  = fileset(path.module, "applications/fast/http/**.tpl")
  fast_json = templatefile("${path.module}/${each.key}")
  template  = "bigip-fast-templates/http"
}

# LDAP Application
resource "bigip_fast_application" "ldap-manifest" {
  for_each  = fileset(path.module, "applications/fast/ldap/**.tpl")
  fast_json = templatefile("${path.module}/${each.key}", { monitor_passphrase = var.ad_service_ldap_password })
  template  = "bigip-fast-templates/ldap"
}