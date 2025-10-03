resource "volterra_known_label_key" "vsite_key" {
  key       = "${var.label-owner}-azure-vsite-key"
  namespace = "shared"
}
resource "volterra_known_label" "vsite_label" {
  key       = volterra_known_label_key.vsite_key.key
  namespace = "shared"
  value     = "${var.label-owner}-azure-vsite-label"
}
resource "volterra_virtual_site" "azure_vsite" {
  name      = "azure-vsite-${random_uuid.ce-random-uuid}"
  namespace = "shared"
  site_selector {
    expressions = [
      "${volterra_known_label_key.vsite_key.key} == ${volterra_known_label.vsite_label.value}"
    ]
  }
  site_type = "CUSTOMER_EDGE"
}
