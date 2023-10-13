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
  round_robin                     = true
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
    direct_response_route {
      http_method = "ANY"
      path {
        prefix = "/"
      }
      incoming_port {
        no_port_match = true

      }
      route_direct_response {
        response_code = 200
        response_body = "{\n    \"message\": \"This is a discovery load balancer\"\n}"
      }
    }
  }
  user_id_client_ip               = true
  disable_rate_limit              = true
  service_policies_from_namespace = true
  cookie_stickiness {
    name = "discoveryStickiness"
  }
  disable_trust_client_ip_headers  = true
  disable_ddos_detection           = true
  disable_malicious_user_detection = true
  disable_api_discovery            = true
  disable_bot_defense              = true
  enable_api_discovery {
    disable_learn_from_redirect_traffic = false
  }
  disable_ip_reputation = true
  no_challenge          = true
  add_location          = true

  // Lifecycle because F5XC adds tags/lables/annotations that terraform doesnt know about
  lifecycle {
    ignore_changes = [labels]
  }

}