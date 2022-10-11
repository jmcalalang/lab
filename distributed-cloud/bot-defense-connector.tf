# Bot Defense Connector for BIG-IP

resource "volterra_botdefense" "bot-defense-connector" {
  name      = "bot-defense-iapp"
  namespace = var.namespace
  labels = {
    "owner" = var.owner
  }
  region           = 3
  custom_connector = true
}
