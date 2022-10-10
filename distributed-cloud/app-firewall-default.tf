resource "volterra_app_firewall" "example" {
  name      = "application-firewall-defualt"
  namespace = var.namespace

  monitoring = true

  // One of the arguments from this list "allow_all_response_codes allowed_response_codes" must be set
  allow_all_response_codes = true

  // One of the arguments from this list "disable_anonymization default_anonymization custom_anonymization" must be set
  default_anonymization = true

  // One of the arguments from this list "use_default_blocking_page blocking_page" must be set
  blocking_page {
    response_code = Forbidden
    blocking_page = "string:///PGh0bWw+PGhlYWQ+PHRpdGxlPkNhbGFsYW5nIFNpdGUgUmVqZWN0ZWQ8L3RpdGxlPjwvaGVhZD48Ym9keT5UaGUgcmVxdWVzdGVkIFVSTCB3YXMgcmVqZWN0ZWQuIFBsZWFzZSBjb25zdWx0IHdpdGggeW91ciBhZG1pbmlzdHJhdG9yLjxici8+PGJyLz5Zb3VyIHN1cHBvcnQgSUQgaXM6IHt7cmVxdWVzdF9pZH19PGJyLz48YnIvPjxhIGhyZWY9ImphdmFzY3JpcHQ6aGlzdG9yeS5iYWNrKCkiPltHbyBCYWNrXTwvYT48L2JvZHk+PC9odG1sPg=="
  }
  enable_threat_campaigns    = true
  default_bot_setting        = true
  default_detection_settings = true
  blocking                   = true
}
