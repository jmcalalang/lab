resource "volterra_cluster" "cluster-nginx-instances" {
  name      = "cluster-nginx-instances"
  namespace = var.namespace
  labels = {
    owner         = var.label-owner
    resource-type = var.label-resource-type
    environment   = var.label-environment
  }
  disable = false
  endpoints {
    namespace = var.namespace
    name      = volterra_endpoint.endpoint-nginx-10-0-3-5.name
  }
  health_checks {
    name      = volterra_healthcheck.health-check-http.name
    namespace = var.namespace
  }
  loadbalancer_algorithm = "LB_OVERRIDE"
}