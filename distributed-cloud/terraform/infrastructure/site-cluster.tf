## F5XC Site Cluster Terraform

# Random uuid generator
resource "random_uuid" "f5xc-azure-site-random-uuid" {
  count = sum([var.f5xc-azure-site-count])
}

resource "volterra_azure_vnet_site" "f5xc-azure-site" {
  name        = "${var.label-owner}-azure-${var.location}-${random_uuid.f5xc-azure-site-random-uuid[0].result}-${count.index}"
  namespace   = var.namespace
  description = "Azure Site ${var.label-owner}-azure-${var.location}-${random_uuid.f5xc-azure-site-random-uuid[0].result}-${count.index}"
  count       = sum([var.f5xc-azure-site-count])
  disable     = false

  // Cordinates of site
  coordinates {
    latitude  = var.f5xc-azure-site-latitude
    longitude = var.f5xc-azure-site-longitude
  }

  // One of the arguments from this list "blocked_services default_blocked_services" must be set
  default_blocked_services = true

  // One of the arguments from this list "azure_cred" must be set
  azure_cred {
    name      = var.f5xc-cloud-credential
    namespace = var.namespace
  }

  // One of the arguments from this list "logs_streaming_disabled log_receiver" must be set
  logs_streaming_disabled = true

  // One of the arguments from this list "azure_region alternate_region" must be set
  azure_region   = var.location
  resource_group = var.f5xc-azure-site-resource-group

  // One of the arguments from this list "ingress_egress_gw voltstack_cluster ingress_gw_ar ingress_egress_gw_ar voltstack_cluster_ar ingress_gw" must be set
  ingress_gw {
    az_nodes {
      azure_az  = "1"
      disk_size = "80"

      local_subnet {
        // One of the arguments from this list "subnet_param subnet" must be set
        subnet {
          vnet_resource_group = true
          subnet_name         = var.existing-vnet-subnet
        }
      }
      performance_enhancement_mode {
        perf_mode_l7_enhanced = true
      }
    }
    azure_certified_hw = var.f5xc-azure-site-offer

    // One of the arguments from this list "no_dc_cluster_group dc_cluster_group" must be set
    no_dc_cluster_group = true

    // One of the arguments from this list "active_forward_proxy_policies forward_proxy_allow_all no_forward_proxy" must be set
    no_forward_proxy = true

    // One of the arguments from this list "no_global_network global_network_list" must be set
    no_global_network = true

    // One of the arguments from this list "k8s_cluster no_k8s_cluster" must be set
    no_k8s_cluster = true

    // One of the arguments from this list "no_network_policy active_network_policies active_enhanced_firewall_policies" must be set
    no_network_policy = true

    // One of the arguments from this list "no_outside_static_routes outside_static_routes" must be set
    no_outside_static_routes = true

    // One of the arguments from this list "sm_connection_public_ip sm_connection_pvt_ip" must be set
    sm_connection_public_ip = true

    // One of the arguments from this list "storage_class_list default_storage" must be set
    default_storage = true
  }
  vnet {
    // One of the arguments from this list "existing_vnet new_vnet" must be set
    existing_vnet {
      // One of the arguments from this list "name autogenerate" must be set
      resource_group = var.existing-vnet-resource-group
      vnet_name      = var.existing-vnet-subnet
    }
  }

  // One of the arguments from this list "nodes_per_az total_nodes no_worker_nodes" must be set
  nodes_per_az = "1"

  // Offline Survivability Mode
  offline_survivability_mode {
    enable_offline_survivability_mode = true
  }

  // Labels
  labels {
    owner         = var.label-owner
    resource-type = var.label-resource-type
    environment   = var.label-environment
  }
}
