# Origin Pool for BIG-IP IngressLink

resource "volterra_origin_pool" "pool-ip-ingresslink" {
  name        = "pool-ip-ingresslink"
  namespace   = var.namespace
  description = "IngressLink BIG-IP Virtual"
  labels = {
    owner         = var.label-owner
    resource-type = var.label-resource-type
    environment   = var.label-environment
  }
  origin_servers {
    private_ip {
      ip              = "10.0.2.8"
      outside_network = true
      site_locator {
        site {
          namespace = "system"
          name      = "calalang-aks-site"
        }
      }
    }
  }
  healthcheck {
    namespace = var.namespace
    name      = volterra_healthcheck.health-check-tcp.name
  }
  endpoint_selection     = "LOCAL_PREFERRED"
  loadbalancer_algorithm = "LB_OVERRIDE"
  port                   = 443
  same_as_endpoint_port  = true
  use_tls {
    disable_sni = true
    tls_config {
      default_security = true
    }
    skip_server_verification = true
    no_mtls                  = true
  }
}