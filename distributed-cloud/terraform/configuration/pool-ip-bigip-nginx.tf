# Origin Pool for BIG-IP NGINX Virtual Servers

resource "volterra_origin_pool" "pool-ip-bigip-nginx" {
  name        = "pool-ip-bigip-nginx"
  namespace   = var.namespace
  description = "BIG-IP NGINX Virtual Server"
  labels = {
    owner         = var.label-owner
    resource-type = var.label-resource-type
    environment   = var.label-environment
  }
  origin_servers {
    private_ip {
      segment {
      }
      ip              = "10.0.2.6"
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