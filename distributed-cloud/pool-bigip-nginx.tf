# Origin Pool for BIG-IP NGINX Virtual Servers

resource "volterra_origin_pool" "bigip-nginx-ip-pool" {
  name        = "bigip-nginx-ip-pool"
  namespace   = var.namespace
  description = "BIG-IP NGINX Virtual Server"
  labels = {
    "owner" = var.owner
  }
  origin_servers {
    private_ip {
      ip              = "10.0.2.14"
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
  port                   = 80
  same_as_endpoint_port  = true
  no_tls                 = true
}