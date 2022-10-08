resource "volterra_healthcheck" "tcp-health-check" {
  name      = tcp-health-check
  namespace = var.namespace
  http_health_check {
  }
  healthy_threshold   = 3
  interval            = 15
  timeout             = 3
  unhealthy_threshold = 3
}