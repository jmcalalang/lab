# HTTP Load Balancer for kubernetes Servers

resource "volterra_http_loadbalancer" "http-lb-kubernetes-calalang-net" {
  name      = "http-lb-kubernetes-calalang-net-test"
  namespace = var.namespace
  labels = {
    "owner" = var.owner
  }
  description                     = "Global HTTPS Load Balancer for kubernetes.calalang.net"
  domains                         = ["test-kubernetes.calalang.net", "test-argo.calalang.net"]
  advertise_on_public_default_vip = true
  round_robin                     = true
  default_route_pools {
    pool {
      name      = volterra_origin_pool.kubernetes-service-pool.name
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