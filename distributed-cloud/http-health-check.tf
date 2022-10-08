resource "volterra_healthcheck" "http-health-check" {
  name      = "http-health-check"
  namespace = var.namespace

  http_health_check {
    use_origin_server_name = false
    path                   = "/"
  }
  healthy_threshold   = 3
  interval            = 15
  timeout             = 3
  unhealthy_threshold = 3
}
