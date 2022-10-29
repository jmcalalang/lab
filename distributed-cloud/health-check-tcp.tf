# Health Check for Generic TCP

resource "volterra_healthcheck" "health-check-tcp" {
  name      = "health-check-tcp"
  namespace = var.namespace
  labels = {
    "owner" = var.owner
  }
  tcp_health_check {
  }
  healthy_threshold   = 3
  interval            = 15
  timeout             = 3
  unhealthy_threshold = 1
  jitter_percent      = 30
}
