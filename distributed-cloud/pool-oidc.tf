# Origin Pool for BIG-IP OIDC Virtual

resource "volterra_origin_pool" "oidc-ip-pool" {
  name        = "oidc-ip-pool"
  namespace   = var.namespace
  description = "OIDC BIG-IP Virtual"
  labels = {
    "owner" = var.owner
  }
  origin_servers {
    private_ip {
      ip              = "10.0.2.51"
      outside_network = true
      site_locator {
        site {
          namespace = var.namespace
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