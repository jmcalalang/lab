# Origin Pool for local NGINX Servers

resource "volterra_origin_pool" "pool-vk8s-nginx-unprivileged" {
  name        = "pool-vk8s-nginx-unprivileged"
  namespace   = var.namespace
  description = "NGINX vk8s unprivileged service"
  labels = {
    "owner" = var.owner
  }
  origin_servers {
    k8s_service {
      service_name = "nginx-unprivileged.j-calalang"
      site_locator {
        virtual_site {
          namespace = "shared"
          name      = "ves-io-all-res"
          tenant    = "ves-io"
        }
      }
      vk8s_networks = true
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