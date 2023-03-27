# HTTP Load Balancer for bigip Servers

resource "volterra_http_loadbalancer" "http-lb-bigip-calalang-net" {
  name      = "http-lb-bigip-calalang-net"
  namespace = var.namespace
  labels = {
    "owner" = var.owner
  }
  description                     = "Global HTTPS Load Balancer for bigip.calalang.net"
  domains                         = ["bigip.calalang.net", "apm.calalang.net", "ingresslink.calalang.net"]
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
          name      = volterra_origin_pool.pool-ip-bigip-nginx.name
        }
        weight           = 1
        priority         = 1
        endpoint_subsets = {}
      }
      headers {
        name         = "HOST"
        exact        = "bigip.calalang.net"
        invert_match = false
      }
      host_rewrite = "bigip.calalang.net"
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
          name      = volterra_origin_pool.pool-ip-apm.name
        }
        weight           = 1
        priority         = 1
        endpoint_subsets = {}
      }
      headers {
        name         = "HOST"
        exact        = "apm.calalang.net"
        invert_match = false
      }
      host_rewrite = "apm.calalang.net"
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
          name      = volterra_origin_pool.pool-ip-ingresslink.name
        }
        weight           = 1
        priority         = 1
        endpoint_subsets = {}
      }
      headers {
        name         = "HOST"
        exact        = "ingresslink.calalang.net"
        invert_match = false
      }
      host_rewrite = "ingresslink.calalang.net"
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
    name = "bigipStickiness"
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