# Origin Pool for local NGINX Servers

resource "volterra_origin_pool" "pool-ip-nginx" {
  name        = "pool-ip-nginx"
  namespace   = var.namespace
  description = "NGINX Servers"
  labels = {
    owner         = var.label-owner
    resource-type = var.label-resource-type
    environment   = var.label-environment
  }
  origin_servers {
    private_ip {
      segment {
      }
      ip              = "10.0.3.5"
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
    name      = volterra_healthcheck.health-check-http.name
  }
  endpoint_selection     = "LOCAL_PREFERRED"
  loadbalancer_algorithm = "LB_OVERRIDE"
  port                   = 80
  same_as_endpoint_port  = true
  no_tls                 = true
}