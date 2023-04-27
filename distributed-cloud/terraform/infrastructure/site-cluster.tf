## F5XC Site Cluster Terraform

# Random uuid generator
resource "random_string" "f5xc-azure-site-random-string" {
  length      = 4
  lower       = true
  special     = false
  min_lower   = 2
  min_numeric = 2
}

resource "volterra_azure_vnet_site" "f5xc-azure-site" {
  name        = "${var.label-owner}-azure-${var.location}-${random_string.f5xc-azure-site-random-string.result}"
  namespace   = "system"
  description = "Azure Site in ${var.location} for ${var.label-owner}"
  disable     = false

  // Machine Type
  machine_type = "Standard_D3_v2"

  // One of the arguments from this list "azure_region alternate_region" must be set
  azure_region   = var.location
  resource_group = var.f5xc-azure-site-resource-group

  // One of the arguments from this list "logs_streaming_disabled log_receiver" must be set
  logs_streaming_disabled = true

  // One of the arguments from this list "nodes_per_az total_nodes no_worker_nodes" must be set
  no_worker_nodes = true

  // One of the arguments from this list "blocked_services default_blocked_services" must be set
  default_blocked_services = true

  // One of the arguments from this list "azure_cred" must be set
  azure_cred {
    name      = var.f5xc-cloud-credential
    namespace = "system"
  }

  // Cordinates of site
  coordinates {
    latitude  = var.f5xc-azure-site-latitude
    longitude = var.f5xc-azure-site-longitude
  }

  // One of the arguments from this list "ingress_egress_gw voltstack_cluster ingress_gw_ar ingress_egress_gw_ar voltstack_cluster_ar ingress_gw" must be set
  ingress_gw {
    azure_certified_hw = var.f5xc-azure-site-offer
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
    }
    az_nodes {
      azure_az  = "2"
      disk_size = "80"

      local_subnet {
        // One of the arguments from this list "subnet_param subnet" must be set
        subnet {
          vnet_resource_group = true
          subnet_name         = var.existing-vnet-subnet
        }
      }
    }
    az_nodes {
      azure_az  = "3"
      disk_size = "80"

      local_subnet {
        // One of the arguments from this list "subnet_param subnet" must be set
        subnet {
          vnet_resource_group = true
          subnet_name         = var.existing-vnet-subnet
        }
      }
    }
    performance_enhancement_mode {
      perf_mode_l7_enhanced = true
    }
  }
  vnet {
    // One of the arguments from this list "existing_vnet new_vnet" must be set
    existing_vnet {
      // One of the arguments from this list "name autogenerate" must be set
      resource_group = var.existing-vnet-resource-group
      vnet_name      = var.existing-vnet
    }
  }

  // Offline Survivability Mode
  offline_survivability_mode {
    enable_offline_survivability_mode = true
  }

  // Labels
  labels = {
    owner             = var.label-owner
    resource-type     = var.label-resource-type
    environment       = var.label-environment
    "ves.io/provider" = "ves-io-AZURE"
    "ves.io/siteType" = "ves-io-ce"
  }
}

# resource "volterra_cloud_site_labels" "labels" {
#   name      = volterra_azure_vnet_site.f5xc-azure-site.name
#   site_type = "azure_vnet_site"
#   labels = {
#   }
#   ignore_on_delete = false
# }

resource "volterra_tf_params_action" "f5xc-azure-site" {
  site_name        = volterra_azure_vnet_site.f5xc-azure-site.name
  site_kind        = "azure_vnet_site"
  action           = "apply"
  wait_for_action  = true
  ignore_on_update = false

  depends_on = [volterra_azure_vnet_site.f5xc-azure-site]
}