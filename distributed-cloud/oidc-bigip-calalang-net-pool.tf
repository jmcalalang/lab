resource "volterra_origin_pool" "oidc-bigip-calalang-net-pool" {
  name                   = "oidc-bigip-calalang-net-tf"
  namespace              = var.namespace
  endpoint_selection     = "LOCAL_PREFERRED"
  loadbalancer_algorithm = "LB_OVERRIDE"

  origin_servers {
    // One of the arguments from this list "custom_endpoint_object private_name k8s_service private_ip consul_service vn_private_ip vn_private_name public_ip public_name" must be set

    private_ip {
      ip = "10.0.2.51"
    }
    site_locator {
      // One of the arguments from this list "site virtual_site" must be set

      site {
        name      = "calalang-volt-rg"
        namespace = "system"
        tenant    = "f5-sa-rnxeudss"
      }
    }
    outside_network {}

    labels = {
      "owner" = var.owner
    }
  }
  use_tls {
    disable_sni              = true
    tls_config               = default_security
    skip_server_verification = true
    no_mtls                  = true
  }
  healthcheck {
    tenant    = f5-sa-rnxeudss
    namespace = j-calalang
    name      = hc-calalang-tcp
    kind      = healthcheck
  }
  // One of the arguments from this list "port automatic_port" must be set
  port = "443"
}
