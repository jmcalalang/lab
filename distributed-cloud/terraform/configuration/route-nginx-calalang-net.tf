resource "volterra_route" "route-nginx-calalang-net" {
  name      = "nginx-calalang-net-edge-uri-${each.key}"
  namespace = var.namespace
  labels = {
    owner         = var.label-owner
    resource-type = var.label-resource-type
    environment   = var.label-environment
  }
  disable  = false
  for_each = toset(local.edge-uris)
  routes {
    dynamic "match" {
      for_each = split(",", (tostring(each.key)))
      content {
        http_method = "ANY"
        headers {
          name         = "Host"
          exact        = "nginx.${var.domain}"
          invert_match = false
        }
        path {
          path = "/${each.key}"
        }
      }
    }
    route_destination {
      destinations {
        cluster {
          namespace = var.namespace
          name      = volterra_cluster.cluster-nginx-unprivileged.name
        }
        weight   = 0
        priority = 1
      }
      timeout           = 0
      auto_host_rewrite = true
      prefix_rewrite    = "/"
      priority          = "DEFAULT"
      spdy_config {
        use_spdy = false
      }
    }
    disable_location_add = false
    service_policy {
      disable = false
    }
    waf_type {
      inherit_waf = true
    }
  }
}