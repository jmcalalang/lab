resource "volterra_cluster" "cluster-nginx-unprivileged" {
  name      = "cluster-nginx-unprivileged"
  namespace = var.namespace
  labels = {
    owner         = var.label-owner
    resource-type = var.label-resource-type
    environment   = var.label-environment
  }
  disable = false
  endpoints {
    namespace = var.namespace
    name      = volterra_endpoint.endpoint-nginx-unprivileged.name
  }
  health_checks {
    name      = volterra_healthcheck.health-check-http.name
    namespace = var.namespace
  }
  loadbalancer_algorithm = "LB_OVERRIDE"
}