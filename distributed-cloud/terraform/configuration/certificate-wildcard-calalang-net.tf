resource "volterra_certificate" "wildcard-calalang-net" {
  name      = "wildcard-calalang-net"
  namespace = var.namespace
  labels = {
    owner         = var.label-owner
    resource-type = var.label-resource-type
    environment   = var.label-environment
  }
  certificate_url = "string:///${var.wildcard_calalang_net_certificate}"
  private_key {
    clear_secret_info {
      url = "string:///${var.wildcard_calalang_net_key}"
    }
  }
  use_system_defaults   = true
  disable_ocsp_stapling = true
}