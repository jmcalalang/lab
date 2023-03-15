# This resource will create and manage FAST applications on BIG-IP from provided JSON declarations.

# LDAP Application
resource "bigip_fast_application" "ldap-10-0-2-5-fast" {
  template  = "bigip-fast-templates/ldap"
  fast_json = templatefile("${path.module}/applications/fast/ldap-10-0-2-5-fast.tpl", { monitor_passphrase = var.ad_service_ldap_password })
}