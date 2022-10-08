resource "volterra_healthcheck" "tcp-health-check" {
  name      = format("%s-health-check", tcp)
  namespace = var.namespace
  http_health_check {
  }
  healthy_threshold   = 3
  interval            = 15
  timeout             = 3
  unhealthy_threshold = 3
}