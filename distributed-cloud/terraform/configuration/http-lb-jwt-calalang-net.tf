# HTTP Load Balancer for JWT example

resource "volterra_http_loadbalancer" "http-lb-jwt-calalang-net" {
  name      = "http-lb-jwt-calalang-net"
  namespace = var.namespace
  labels = {
    owner         = var.label-owner
    resource-type = var.label-resource-type
    environment   = var.label-environment
  }
  description                     = "Global HTTPS Load Balancer for jwt.calalang.net"
  domains                         = ["jwt.calalang.net"]
  advertise_on_public_default_vip = true
  default_route_pools {
    pool {
      name      = volterra_origin_pool.pool-vk8s-nginx-unprivileged.name
      namespace = var.namespace
    }
    weight   = 1
    priority = 1
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
  add_location = true
  cookie_stickiness {
    name = "JWTStickiness"
  }
  disable_rate_limit               = true
  disable_trust_client_ip_headers  = true
  disable_ddos_detection           = true
  disable_malicious_user_detection = true
  disable_bot_defense              = true
  disable_api_definition           = true
  disable_ip_reputation            = true
  disable_api_discovery            = true
  jwt_validation {
    target {
      all_endpoint = true
    }
    token_location {
      bearer_token = true
    }
    action {
      block = true
    }
    jwks_config {
      cleartext = "string:///${var.jwk-calalang-net}"
    }
    reserved_claims {
      issuer                  = var.domain
      audience_disable        = true
      validate_period_disable = true
    }
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