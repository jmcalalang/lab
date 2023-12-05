resource "volterra_route" "route-discovery-calalang-net" {
  name      = "route-discovery-calalang-net"
  namespace = var.namespace
  labels = {
    owner         = var.label-owner
    resource-type = var.label-resource-type
    environment   = var.label-environment
  }
  disable = false
  routes {
    match {
      path {
        prefix = "/"
      }
      headers {
        name         = "Host"
        exact        = "discovery.${var.domain}"
        invert_match = false
      }
    }
    route_direct_response {
      response_code = 200
      response_body = "{\r\n    \"message\": \"This is a discovery load balancer\"\r\n}"
    }
    response_headers_to_add {
      append = true
      name   = "Content-Type"

      // One of the arguments from this list "value secret_value" must be set
      value = "application/json"
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