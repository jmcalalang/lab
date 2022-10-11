# Origin Pool for local NGINX Servers

resource "volterra_origin_pool" "nginx-pool" {
  name      = "nginx-ip-pool"
  namespace = var.namespace
  labels = {
    "owner" = var.owner
  }
  origin_servers {
    private_ip {
      ip              = "10.0.2.7"
      outside_network = true
      site_locator {
        site {
          tenant    = "f5-sa"
          namespace = "j-calalang"
          name      = "calalang-volt-rg"
          kind      = "site"
        }
      }
    }
    private_ip {
      ip              = "10.0.2.6"
      outside_network = true
      site_locator {
        site {
          tenant    = "f5-sa"
          namespace = "j-calalang"
          name      = "calalang-volt-rg"
          kind      = "site"
        }
      }
    }
  }
  healthcheck = {
    tenant    = f5-sa-rnxeudss
    namespace = j-calalang
    name      = http-health-check
    kind      = healthcheck
  }
  endpoint_selection     = "LOCAL_PREFERRED"
  loadbalancer_algorithm = "LB_OVERRIDE"
  port                   = 80
  same_as_endpoint_port  = true
  no_tls                 = true
}