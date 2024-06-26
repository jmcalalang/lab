# HTTP Load Balancer for NGINX Servers

# Load Balancer
resource "volterra_http_loadbalancer" "http-lb-nginx-calalang-net" {
  name      = "http-lb-nginx-calalang-net"
  namespace = var.namespace
  labels = {
    owner         = var.label-owner
    resource-type = var.label-resource-type
    environment   = var.label-environment
  }
  description                     = "Global HTTPS Load Balancer for nginx.calalang.net"
  domains                         = ["nginx.calalang.net"]
  advertise_on_public_default_vip = true
  default_route_pools {
    pool {
      name      = volterra_origin_pool.pool-ip-nginx.name
      namespace = var.namespace
    }
    weight   = 1
    priority = 1
  }
  routes {
    custom_route_object {
      route_ref {
        namespace = var.namespace
        name      = "nginx-calalang-net-edge-uri-edge"
      }
    }
  }
  routes {
    custom_route_object {
      route_ref {
        namespace = var.namespace
        name      = "nginx-calalang-net-edge-uri-global"
      }
    }
  }
  routes {
    custom_route_object {
      route_ref {
        namespace = var.namespace
        name      = "nginx-calalang-net-edge-uri-re"
      }
    }
  }
  routes {
    custom_route_object {
      route_ref {
        namespace = var.namespace
        name      = "nginx-calalang-net-edge-uri-vk8s"
      }
    }
  }
  https {
    http_redirect = true
    add_hsts      = true
    port          = 443
    tls_cert_params {
      certificates {
        namespace = var.namespace
        name      = volterra_certificate.wildcard-calalang-net.name
      }
    }
  }
  app_firewall {
    name      = volterra_app_firewall.app-firewall-threat-campaigns.name
    namespace = var.namespace
  }
  waf_exclusion_rules {
    metadata {
      name = "waf-exclusion-rules"
    }
    exact_value = "nginx.calalang.net"
    methods     = ["GET"]
    app_firewall_detection_control {
      exclude_signature_contexts {
        signature_id = 200000001
        context      = "CONTEXT_URL"
      }
      exclude_signature_contexts {
        signature_id = 200000002
        context      = "CONTEXT_URL"
      }
    }
  }
  add_location = true
  cookie_stickiness {
    name = "NGINXStickiness"
  }
  disable_rate_limit               = true
  disable_trust_client_ip_headers  = true
  disable_malicious_user_detection = true
  disable_api_discovery            = true
  disable_bot_defense              = true
  disable_api_definition           = true
  disable_ip_reputation            = true
  no_challenge                     = true
  round_robin                      = true
  service_policies_from_namespace  = true
  user_id_client_ip                = true

  // Lifecycle because F5XC adds tags/lables/annotations that terraform doesnt know about
  lifecycle {
    ignore_changes = [labels]
  }

}
