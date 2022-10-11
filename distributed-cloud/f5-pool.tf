# Origin Pool for F5.com

resource "volterra_origin_pool" "f5-pool" {
  name      = "f5-dns-pool"
  namespace = var.namespace
  labels = {
    "owner" = var.owner
  }
  endpoint_selection     = "DISTRIBUTED"
  loadbalancer_algorithm = "ROUND_ROBIN"
  origin_servers {
    public_name {
      dns_name = "f5.com"
    }
  }
  port   = "443"
  no_tls = true
}
