# Application firewall with Threat Campaigns and Custom Block Page

resource "volterra_app_firewall" "app-firewall-threat-campaigns" {
  name      = "app-firewall-threat-campaigns"
  namespace = var.namespace
  labels = {
    owner         = var.label-owner
    resource-type = var.label-resource-type
    environment   = var.label-environment
  }
  monitoring               = true
  allow_all_response_codes = true
  default_anonymization    = true
  blocking                 = true
  enable_ai_enhancements {
    mitigate_high_risk_action = true
  }
  ai_risk_based_blocking {
    high_risk_action   = "AI_BLOCK"
    medium_risk_action = "AI_BLOCK"
    low_risk_action    = "AI_BLOCK"
  }
  blocking_page {
    response_code = "Forbidden"
    blocking_page = "string:///PGh0bWw+PGhlYWQ+PHRpdGxlPkNhbGFsYW5nIFNpdGUgUmVqZWN0ZWQ8L3RpdGxlPjwvaGVhZD48Ym9keT5UaGUgcmVxdWVzdGVkIFVSTCB3YXMgcmVqZWN0ZWQuIFBsZWFzZSBjb25zdWx0IHdpdGggeW91ciBhZG1pbmlzdHJhdG9yLjxici8+PGJyLz5Zb3VyIHN1cHBvcnQgSUQgaXM6IHt7cmVxdWVzdF9pZH19PGJyLz48YnIvPjxhIGhyZWY9ImphdmFzY3JpcHQ6aGlzdG9yeS5iYWNrKCkiPltHbyBCYWNrXTwvYT48L2JvZHk+PC9odG1sPg=="
  }
}
