# HTTP Load Balancer for kubernetes Servers

resource "volterra_http_loadbalancer" "http-lb-kubernetes-calalang-net" {
  name      = "http-lb-kubernetes-calalang-net"
  namespace = var.namespace
  labels = {
    "owner" = var.owner
  }
  description                     = "Global HTTPS Load Balancer for kubernetes.calalang.net"
  domains                         = ["kubernetes.calalang.net", "argo.calalang.net", "nms.calalang.net", "jwt.nms.calalang.net"]
  advertise_on_public_default_vip = true
  round_robin                     = true
  routes {
    simple_route {
      http_method = "ANY"
      path {
        regex = ".*"
      }
      origin_pools {
        pool {
          namespace = var.namespace
          name      = volterra_origin_pool.pool-svc-nginx-ingress.name
        }
        weight           = 1
        priority         = 1
        endpoint_subsets = {}
      }
      headers {
        name         = "HOST"
        exact        = "kubernetes.calalang.net"
        invert_match = false
      }
      host_rewrite = "kubernetes.calalang.net"
    }
  }
  routes {
    simple_route {
      http_method = "ANY"
      path {
        regex = ".*"
      }
      origin_pools {
        pool {
          namespace = var.namespace
          name      = volterra_origin_pool.pool-svc-nginx-ingress.name
        }
        weight           = 1
        priority         = 1
        endpoint_subsets = {}
      }
      headers {
        name         = "HOST"
        exact        = "argo.calalang.net"
        invert_match = false
      }
      host_rewrite = "argo.calalang.net"
    }
  }
  routes {
    simple_route {
      http_method = "ANY"
      path {
        regex = ".*"
      }
      origin_pools {
        pool {
          namespace = var.namespace
          name      = volterra_origin_pool.pool-svc-nginx-ingress.name
        }
        weight           = 1
        priority         = 1
        endpoint_subsets = {}
      }
      headers {
        name         = "HOST"
        exact        = "nms.calalang.net"
        invert_match = false
      }
      host_rewrite = "nms.calalang.net"
    }
  }
  routes {
    simple_route {
      http_method = "ANY"
      path {
        regex = ".*"
      }
      origin_pools {
        pool {
          namespace = var.namespace
          name      = volterra_origin_pool.pool-svc-nginx-ingress.name
        }
        weight           = 1
        priority         = 1
        endpoint_subsets = {}
      }
      headers {
        name         = "HOST"
        exact        = "jwt.nms.calalang.net"
        invert_match = false
      }
      host_rewrite = "jwt.nms.calalang.net"
    }
  }
  https_auto_cert {
    add_hsts              = true
    http_redirect         = true
    no_mtls               = true
    enable_path_normalize = true
  }
  app_firewall {
    name      = volterra_app_firewall.app-firewall-threat-campaigns.name
    namespace = var.namespace
  }
  user_id_client_ip               = true
  disable_rate_limit              = true
  service_policies_from_namespace = true
  cookie_stickiness {
    name = "kubernetesStickiness"
  }
  disable_trust_client_ip_headers  = true
  disable_ddos_detection           = true
  disable_malicious_user_detection = true
  disable_api_discovery            = true
  disable_bot_defense              = true
  disable_api_definition           = true
  disable_ip_reputation            = true
  no_challenge                     = true
  add_location                     = true

}