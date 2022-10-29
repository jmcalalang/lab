# Origin Pool for F5 Entities

resource "volterra_origin_pool" "pool-dns-f5" {
  name        = "pool-dns-f5"
  namespace   = var.namespace
  description = "F5 Entities Origin Pools"
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
    name      = volterra_healthcheck.health-check-tcp.name
  }
  port                   = "443"
  no_tls                 = true
  endpoint_selection     = "DISTRIBUTED"
  loadbalancer_algorithm = "ROUND_ROBIN"
}
