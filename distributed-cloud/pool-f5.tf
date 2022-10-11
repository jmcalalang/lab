# Origin Pool for F5.com

resource "volterra_origin_pool" "f5-dns-pool" {
  name        = "f5-dns-pool"
  namespace   = var.namespace
  description = "F5 Business Origin Pools"
  labels = {
    "owner" = var.owner
  }
  origin_servers {
    public_name {
      dns_name = "f5.com"
    }
  }
  origin_servers {
    public_name {
      dns_name = "nginx.com"
    }
  }
  origin_servers {
    public_name {
      dns_name = "volterra.io"
    }
  }
  origin_servers {
    public_name {
      dns_name = "shapesecurity.com"
    }
  }
  origin_servers {
    public_name {
      dns_name = "threatstack.com"
    }
  }
  origin_servers {
    public_name {
      dns_name = "aspenmesh.io"
    }
  }
  healthcheck {
    namespace = var.namespace
    name      = "tcp-health-check"
  }
  port                   = "443"
  no_tls                 = true
  endpoint_selection     = "DISTRIBUTED"
  loadbalancer_algorithm = "ROUND_ROBIN"
}
