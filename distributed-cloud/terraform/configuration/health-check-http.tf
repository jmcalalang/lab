# Health Check for Generic HTTP

resource "volterra_healthcheck" "health-check-http" {
  name      = "health-check-http"
  namespace = var.namespace
  labels = {
    "owner" = var.owner
  }
  http_health_check {
    use_origin_server_name = false
    path                   = "/"
    use_http2              = false
  }
  healthy_threshold   = 3
  interval            = 15
  timeout             = 3
  unhealthy_threshold = 1
  jitter_percent      = 30
}
