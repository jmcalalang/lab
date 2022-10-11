# Origin Pool for F5.com

resource "volterra_origin_pool" "f5pool" {
  name      = "f5pool"
  namespace = var.namespace
  labels = {
    "owner" = var.owner
  }
  origin_servers {
    public_name {
      dns_name = "f5.com"
    }
  }
  port                   = "443"
  no_tls                 = true
  endpoint_selection     = "DISTRIBUTED"
  loadbalancer_algorithm = "ROUND_ROBIN"
}
