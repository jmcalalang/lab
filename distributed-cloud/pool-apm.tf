# Origin Pool for BIG-IP APM

resource "volterra_origin_pool" "apm-ip-pool" {
  name        = "apm-ip-pool"
  namespace   = var.namespace
  description = "APM BIG-IP Virtual"
  labels = {
    "owner" = var.owner
  }
  origin_servers {
    private_ip {
      ip              = "10.0.2.12"
      outside_network = true
      site_locator {
        site {
          namespace = "system"
          name      = "calalang-volt-rg"
        }
      }
    }
  }
  healthcheck {
    namespace = var.namespace
    name      = "tcp-health-check"
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