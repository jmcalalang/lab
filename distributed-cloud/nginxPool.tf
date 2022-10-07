resource "volterra_origin_pool" "nginxPool" {
  name                   = "nginx-pool"
  namespace              = var.namespace
  endpoint_selection     = "DISTRIBUTED"
  loadbalancer_algorithm = "ROUND_ROBIN"

  origin_servers {
    // One of the arguments from this list "custom_endpoint_object private_name k8s_service private_ip consul_service vn_private_ip vn_private_name public_ip public_name" must be set

    public_name {
      dns_name = "nginx.com"
    }

    labels = {
      "owner" = var.owner
    }
  }

  // One of the arguments from this list "port automatic_port" must be set
  port = "443"

  // One of the arguments from this list "no_tls use_tls" must be set
  no_tls = true
}
