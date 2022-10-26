# HTTP Load Balancer for NGINX Servers

resource "volterra_http_loadbalancer" "http-lb-nginx-calalang-net" {
  name      = "http-lb-nginx-calalang-net"
  namespace = var.namespace
  labels = {
    "owner" = var.owner
  }
  description                     = "Global HTTPS Load Balancer for nginx.calalang.net"
  domains                         = ["nginx.calalang.net"]
  advertise_on_public_default_vip = true
  round_robin                     = true
  default_route_pools {
    pool {
      name      = volterra_origin_pool.nginx-ip-pool.name
      namespace = var.namespace
    }
    weight   = 1
    priority = 1
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
    name = "NGINXStickiness"
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

# GoDaddy F5XC Challenge and Redirect

resource "godaddy_domain_record" "http-lb-nginx-calalang-net" {
  domain = "calalang.net"

  record {
    name = "_acme-challenge.nginx"
    type = "CNAME"
    data = "ae0fdf7d254743afa2cd2519a18b3fb1.autocerts.ves.volterra.io."
    ttl  = 3600
  }

  record {
    name = "nginx"
    type = "CNAME"
    data = "ves-io-b29d0700-76fb-4999-9967-b5f34e6f4ea7.ac.vh.ves.io."
    ttl  = 3600
  }

}