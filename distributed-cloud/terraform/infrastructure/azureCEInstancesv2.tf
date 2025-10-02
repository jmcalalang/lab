## Terraform Configuration for F5 XC Customer Edge (CE) on Azure

## Shared Variables

resource "random_uuid" "ce-random-uuid" {
  count = sum([var.ce-instance-count])
}

## Azure SSH Key
resource "tls_private_key" "ce-ssh-key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

## Azure Resource Group for F5 XC resources

resource "azurerm_resource_group" "f5-xc-resource-group" {
  name     = var.f5xc-azure-site-resource-group
  location = var.location
  tags = {
    environment = var.label-environment
    resource    = var.label-resource-type
    Owner       = var.label-email
  }
}

## Azure Network Objects for F5 XC resources

data "azurerm_subnet" "existing-subnet-internal" {
  name                 = var.existing-vnet-subnet-internal
  virtual_network_name = var.existing-vnet
  resource_group_name  = var.existing-vnet-resource-group
}

data "azurerm_subnet" "existing-subnet-external" {
  name                 = var.existing-vnet-subnet-external
  virtual_network_name = var.existing-vnet
  resource_group_name  = var.existing-vnet-resource-group
}

resource "azurerm_public_ip" "ce-management" {
  name                = "pip-${random_uuid.ce-random-uuid[0].result}-${count.index}"
  location            = azurerm_resource_group.f5-xc-resource-group.location
  resource_group_name = azurerm_resource_group.f5-xc-resource-group.name
  allocation_method   = "Static"
  count               = sum([var.ce-instance-count])
  domain_name_label   = "ce-${random_uuid.ce-random-uuid[0].result}-${count.index}"
  tags = {
    environment = var.label-environment
    resource    = var.label-resource-type
    Owner       = var.label-email
  }
}

resource "azurerm_network_interface" "nic-internal" {
  name                           = "nic-internal-${random_uuid.ce-random-uuid[0].result}-${count.index}"
  location                       = azurerm_resource_group.f5-xc-resource-group.location
  resource_group_name            = azurerm_resource_group.f5-xc-resource-group.name
  count                          = sum([var.ce-instance-count])
  ip_forwarding_enabled          = false
  accelerated_networking_enabled = false
  ip_configuration {
    name                          = "if-config-internal-01"
    subnet_id                     = data.azurerm_subnet.existing-subnet-internal.id
    private_ip_address_allocation = "Dynamic"
    primary                       = true
  }
  tags = {
    environment = var.label-environment
    resource    = var.label-resource-type
    Owner       = var.label-email
  }
}

resource "azurerm_network_interface" "nic-external" {
  name                           = "nic-external-${random_uuid.ce-random-uuid[0].result}-${count.index}"
  location                       = azurerm_resource_group.f5-xc-resource-group.location
  resource_group_name            = azurerm_resource_group.f5-xc-resource-group.name
  count                          = sum([var.ce-instance-count])
  ip_forwarding_enabled          = false
  accelerated_networking_enabled = false
  ip_configuration {
    name                          = "if-config-external-01"
    subnet_id                     = data.azurerm_subnet.existing-subnet-external.id
    private_ip_address_allocation = "Dynamic"
    primary                       = true
    public_ip_address_id          = azurerm_public_ip.ce-management[count.index].id
  }
  tags = {
    environment = var.label-environment
    resource    = var.label-resource-type
    Owner       = var.label-email
  }
}

resource "azurerm_network_security_group" "ce-external-sg" {
  name                = "ce-external-sg"
  location            = azurerm_resource_group.f5-xc-resource-group.location
  resource_group_name = azurerm_resource_group.f5-xc-resource-group.name
  security_rule {
    name                       = "ce-ui"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "65500"
    source_address_prefixes    = tolist([var.allowed_ips])
    destination_address_prefix = "*"
  }
  tags = {
    environment = var.label-environment
    resource    = var.label-resource-type
    Owner       = var.label-email
  }
}

resource "azurerm_network_interface_security_group_association" "ce-external-sg" {
  network_interface_id      = azurerm_network_interface.nic-external[count.index].id
  network_security_group_id = azurerm_network_security_group.ce-external-sg.id
  count                     = sum([var.ce-instance-count])
}

## F5 XC resources Tokens, Sites, and Virtual Sites

resource "volterra_known_label_key" "vsite_key" {
  key       = "azure-vsite-key-${random_uuid.ce-random-uuid[0].result}-${count.index}"
  namespace = "shared"
  count     = var.ce-instance-count
}

resource "volterra_known_label" "vsite_label" {
  key       = volterra_known_label_key.vsite_key[count.index].key
  namespace = "shared"
  value     = "azure-vsite-label-${random_uuid.ce-random-uuid[0].result}-${count.index}"
  count     = var.ce-instance-count
}

resource "volterra_securemesh_site_v2" "azure-site" {

  name                    = "azure-site-${random_uuid.ce-random-uuid[0].result}-${count.index}"
  namespace               = "system"
  block_all_services      = false
  logs_streaming_disabled = true
  enable_ha               = false
  count                   = var.ce-instance-count
  tunnel_type             = "SITE_TO_SITE_TUNNEL_SSL"
  re_select {
    geo_proximity = true
  }
  azure {
    not_managed {}
  }
  labels = {
    "ves.io/provider" = "ves-io-AZURE"
  }
}

resource "volterra_token" "smsv2_token" {
  name      = "smsv2-token-${random_uuid.ce-random-uuid[0].result}-${count.index}"
  namespace = "system"
  type      = 1
  site_name = volterra_securemesh_site_v2.azure-site[count.index].name
  count     = var.ce-instance-count
}

resource "volterra_virtual_site" "azure_vsite" {
  name      = "azure-vsite-${random_uuid.ce-random-uuid[0].result}-${count.index}"
  namespace = "shared"
  site_selector {
    expressions = [
      "${volterra_known_label_key.vsite_key[count.index].key} == ${volterra_known_label.vsite_label[count.index].value}"
    ]
  }
  site_type = "CUSTOMER_EDGE"
  count     = var.ce-instance-count
}

## Azure Instances for F5 XC Customer Edge (CE)

resource "azurerm_linux_virtual_machine" "ce-instance" {
  name                = "ce-${random_uuid.ce-random-uuid[0].result}-${count.index}"
  location            = azurerm_resource_group.f5-xc-resource-group.location
  resource_group_name = azurerm_resource_group.f5-xc-resource-group.name
  network_interface_ids = [
    azurerm_network_interface.nic-external[count.index].id,
    azurerm_network_interface.nic-internal[count.index].id
  ]
  size                            = var.ce-instance-size
  availability_set_id             = azurerm_availability_set.ce-instance.id
  count                           = sum([var.ce-instance-count])
  admin_username                  = var.f5xc_ce_username
  disable_password_authentication = true
  computer_name                   = "ce-${random_uuid.ce-random-uuid[0].result}-${count.index}"
  custom_data                     = base64encode(data.cloudinit_config.f5xc_ce_config[count.index].rendered)
  admin_ssh_key {
    username   = "cloud-user"
    public_key = trimsuffix(tls_private_key.ce-ssh-key.public_key_openssh, "\n")
  }
  boot_diagnostics {
  }
  plan {
    publisher = var.ce-publisher
    product   = var.ce-offer
    name      = var.ce-sku
  }
  source_image_reference {
    publisher = var.ce-publisher
    offer     = var.ce-offer
    sku       = var.ce-sku
    version   = var.ce-version
  }
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = 128
  }
  identity {
    type = "SystemAssigned"
  }
  tags = {
    environment = var.label-environment
    resource    = var.label-resource-type
    Owner       = var.label-email
  }
}

data "cloudinit_config" "f5xc_ce_config" {
  count         = var.ce-instance-count
  gzip          = false
  base64_encode = false

  part {
    content_type = "text/cloud-config"
    content = yamlencode({
      #cloud-config
      write_files = [
        {
          path        = "/etc/vpm/user_data"
          permissions = "0644"
          owner       = "root"
          content     = <<-EOT
            token: ${trimsuffix(volterra_token.smsv2_token[count.index].id, "\n")}
          EOT
        }
      ]
    })
  }
}

## Availability Set
resource "azurerm_availability_set" "ce-instance" {
  name                = "aset-${random_uuid.ce-random-uuid[0].result}"
  location            = azurerm_resource_group.f5-xc-resource-group.location
  resource_group_name = azurerm_resource_group.f5-xc-resource-group.name
  tags = {
    environment = var.label-environment
    resource    = var.label-resource-type
    Owner       = var.label-email
  }
}

## Shutdown Schedule
resource "azurerm_dev_test_global_vm_shutdown_schedule" "ce-instance-group-azure-instances" {
  virtual_machine_id    = azurerm_linux_virtual_machine.ce-instance[count.index].id
  location              = azurerm_resource_group.f5-xc-resource-group.location
  enabled               = true
  daily_recurrence_time = "1900"
  timezone              = "Pacific Standard Time"
  count                 = sum([var.ce-instance-count])
  notification_settings {
    enabled         = true
    time_in_minutes = "30"
    email           = var.label-email
  }
}
