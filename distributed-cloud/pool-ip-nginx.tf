# Origin Pool for local NGINX Servers

resource "volterra_origin_pool" "pool-ip-nginx" {
  name        = "pool-ip-nginx"
  namespace   = var.namespace
  description = "NGINX Servers"
  labels = {
    "owner" = var.owner
  }
  origin_servers {
    private_ip {
      ip              = "10.0.2.6"
      outside_network = true
      site_locator {
        site {
          namespace = "system"
          name      = "calalang-volt-rg"
        }
      }
    }
  }
  origin_servers {
    private_ip {
      ip              = "10.0.2.7"
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
    name      = volterra_healthcheck.health-check-http.name
  }
  endpoint_selection     = "LOCAL_PREFERRED"
  loadbalancer_algorithm = "LB_OVERRIDE"
  port                   = 80
  same_as_endpoint_port  = true
  no_tls                 = true
}