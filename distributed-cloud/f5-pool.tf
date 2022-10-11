# Origin Pool for F5.com

resource "volterra_origin_pool" "f5-dns-pool" {
  name      = "f5-dns-pool"
  namespace = var.namespace
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
    namespace = "j-calalang"
    name      = "tcp-health-check"
  }
  port                   = "443"
  no_tls                 = true
  endpoint_selection     = "DISTRIBUTED"
  loadbalancer_algorithm = "ROUND_ROBIN"
}
