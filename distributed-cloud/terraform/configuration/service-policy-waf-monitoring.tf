# Service Policy for WAF monitoring

resource "volterra_service_policy" "service_policy_waf_monitoring" {
  name      = "service-policy-waf-monitoring"
  namespace = var.namespace
  labels = {
    owner         = var.label-owner
    resource-type = var.label-resource-type
    environment   = var.label-environment
  }
  algo       = "FIRST_MATCH"
  any_server = true
  rule_list {
    rules {
      metadata {
        name    = "waf-monitor"
        disable = false
      }
      spec {
        action     = "ALLOW"
        any_client = true
        ip_prefix_list {
          ip_prefixes  = ["1.1.1.1/32"]
          invert_match = false
        }
        challenge_action = "DEFAULT_CHALLENGE"
        waf_action {
          waf_in_monitoring_mode = true
        }
      }
    }
  }
}