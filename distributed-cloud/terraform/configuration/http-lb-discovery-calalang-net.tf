# HTTP Load Balancer for Discovery Service

resource "volterra_http_loadbalancer" "http-lb-discovery-calalang-net" {
  name      = "http-lb-discovery-calalang-net"
  namespace = var.namespace
  labels = {
    owner         = var.label-owner
    resource-type = var.label-resource-type
    environment   = var.label-environment
  }
  description                     = "Global HTTPS Load Balancer for discovery.calalang.net"
  domains                         = ["discovery.calalang.net"]
  advertise_on_public_default_vip = true
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
  routes {
    custom_route_object {
      route_ref {
        namespace = var.namespace
        name      = "route-discovery-calalang-net"
      }
    }
  }
  add_location = true
  app_firewall {
    name      = volterra_app_firewall.app-firewall-threat-campaigns.name
    namespace = var.namespace
  }
  cookie_stickiness {
    name = "discoveryStickiness"
  }
  disable_bot_defense              = true
  disable_ddos_detection           = true
  disable_ip_reputation            = true
  disable_malicious_user_detection = true
  disable_rate_limit               = true
  enable_api_discovery {
    disable_learn_from_redirect_traffic = true
  }
  enable_trust_client_ip_headers {
    client_ip_headers = ["X-Forwarded-For"]
  }
  no_challenge                    = true
  round_robin                     = true
  service_policies_from_namespace = true
  user_id_client_ip               = true

  // Lifecycle because F5XC adds tags/lables/annotations that terraform doesnt know about
  lifecycle {
    ignore_changes = [labels]
  }

}
