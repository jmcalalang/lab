resource "volterra_endpoint" "endpoint-nginx-10-0-3-11" {
  name      = "endpoint-nginx-10-0-3-11"
  namespace = var.namespace
  labels = {
    owner         = var.label-owner
    resource-type = var.label-resource-type
    environment   = var.label-environment
  }
  disable           = false
  protocol          = "TCP"
  port              = 80
  health_check_port = 80
  ip                = "10.0.3.11"
  where {
    site {
      ref {
        name = "calalang-aks-site"
      }
      network_type         = "VIRTUAL_NETWORK_SITE_LOCAL_INSIDE_OUTSIDE"
      disable_internet_vip = true
    }
  }
}