resource "volterra_known_label" "vsite_label" {
  key        = volterra_known_label_key.vsite_key.key
  namespace  = "shared"
  value      = "${var.label-owner}-azure-vsite-label"
  depends_on = [volterra_known_label_key.vsite_key]
}
resource "volterra_known_label_key" "vsite_key" {
  key       = "${var.label-owner}-azure-vsite-key"
  namespace = "shared"
}
resource "volterra_virtual_site" "azure_vsite" {
  name       = "${var.label-owner}-azure-vsite"
  namespace  = "shared"
  site_type  = "CUSTOMER_EDGE"
  depends_on = [volterra_known_label.vsite_label, volterra_known_label_key.vsite_key]
  site_selector {
    expressions = [
      "${volterra_known_label_key.vsite_key.key} == ${volterra_known_label.vsite_label.value}"
    ]
  }
}
