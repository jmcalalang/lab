resource "volterra_endpoint" "endpoint-nginx-unprivileged" {
  name      = "endpoint-nginx-unprivileged"
  namespace = var.namespace
  labels = {
    owner         = var.label-owner
    resource-type = var.label-resource-type
    environment   = var.label-environment
  }
  disable           = false
  protocol          = "TCP"
  port              = 80
  health_check_port = 0
  service_info {
    discovery_type = "K8S"
    service_name   = "nginx-unprivileged.${var.namespace}"
  }
  where {
    virtual_site {
      ref {
        name = "ves-io-all-res"
        tenant = "ves-io"
        namespace = "shared"
      }
      network_type         = "VIRTUAL_NETWORK_SITE_LOCAL"
      disable_internet_vip = true
    }
  }
}