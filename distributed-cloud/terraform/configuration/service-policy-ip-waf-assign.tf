# Service Policy for WAF monitoring

resource "volterra_service_policy" "service_policy_waf_monitoring" {
  name      = "service-policy-waf-monitoring"
  namespace = var.namespace
  labels = {
    owner         = var.label-owner
    resource-type = var.label-resource-type
    environment   = var.label-environment
  }
  action = "ALLOW"
  // One of the arguments from this list "any_asn asn_list asn_matcher" must be set
  any_asn          = true
  challenge_action = "DEFAULT_CHALLENGE"

  // One of the arguments from this list "any_client client_name ip_threat_category_list client_selector client_name_matcher" must be set

  any_client = true

  // One of the arguments from this list "any_ip ip_prefix_list ip_matcher" must be set

  ip_prefix_list {
    invert_match = false
    ip_prefixes  = ["192.168.20.0/24"]
  }
  waf_action {
    // One of the arguments from this list "none waf_skip_processing waf_in_monitoring_mode app_firewall_detection_control data_guard_control" must be set
    waf_in_monitoring_mode = true
  }
}