# Origin Pool for NGINX Ingress Controller

resource "volterra_origin_pool" "kubernetes-service-pool" {
  name        = "kubernetes-service-pool"
  namespace   = var.namespace
  description = "NGINX Ingress Controller Service"
  labels = {
    "owner" = var.owner
  }
  origin_servers {
    k8s_service {
      service_name    = "nginx-ingress.nginx-ingress"
      outside_network = true
      site_locator {
        site {
          namespace = "system"
          name      = "calalang-aks-cluster"
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