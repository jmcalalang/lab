# Application firewall with Threat Campaigns and Custom Block Page

resource "volterra_app_firewall" "app-firewall-threat-campaigns" {
  name      = "app-firewall-threat-campaigns"
  namespace = var.namespace
  labels = {
    owner         = var.label-owner
    resource-type = var.label-resource-type
    environment   = var.label-environment
  }
  blocking_page {
    response_code = "Forbidden"
    blocking_page = "string:///PGh0bWw+PGhlYWQ+PHRpdGxlPkNhbGFsYW5nIFNpdGUgUmVqZWN0ZWQ8L3RpdGxlPjwvaGVhZD48Ym9keT5UaGUgcmVxdWVzdGVkIFVSTCB3YXMgcmVqZWN0ZWQuIFBsZWFzZSBjb25zdWx0IHdpdGggeW91ciBhZG1pbmlzdHJhdG9yLjxici8+PGJyLz5Zb3VyIHN1cHBvcnQgSUQgaXM6IHt7cmVxdWVzdF9pZH19PGJyLz48YnIvPjxhIGhyZWY9ImphdmFzY3JpcHQ6aGlzdG9yeS5iYWNrKCkiPltHbyBCYWNrXTwvYT48L2JvZHk+PC9odG1sPg=="
  }
  detection_settings {
    signature_selection_setting {
      default_attack_type_settings    = true
      high_medium_accuracy_signatures = true
    }
    enable_threat_campaigns    = true
    enable_suppression         = true
    default_violation_settings = true
  }
  monitoring               = true
  allow_all_response_codes = true
  default_anonymization    = true
  blocking                 = true
}