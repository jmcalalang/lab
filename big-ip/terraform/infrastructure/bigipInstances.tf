################################# Azure BIG-IP Instances #################################

## Azure Network Objects
resource "random_uuid" "pip-mgmt-random-uuid" {
  count = sum([var.big-ip-instance-count])
}

data "azurerm_subscription" "primary" {
}

data "azurerm_subnet" "existing-subnet-management" {
  name                 = var.existing_subnet_management_name
  virtual_network_name = var.existing_subnet_vnet
  resource_group_name  = var.existing_subnet_resource_group
}

data "azurerm_subnet" "existing-subnet-internal" {
  name                 = var.existing_subnet_internal_name
  virtual_network_name = var.existing_subnet_vnet
  resource_group_name  = var.existing_subnet_resource_group
}

data "azurerm_subnet" "existing-subnet-external" {
  name                 = var.existing_subnet_external_name
  virtual_network_name = var.existing_subnet_vnet
  resource_group_name  = var.existing_subnet_resource_group
}

resource "azurerm_public_ip" "public-ip-address-management" {
  name                = "pip-${random_uuid.pip-mgmt-random-uuid[0].result}-${count.index}"
  location            = azurerm_resource_group.big-ip-resource-group.location
  resource_group_name = azurerm_resource_group.big-ip-resource-group.name
  allocation_method   = "Dynamic"
  count               = sum([var.big-ip-instance-count])
  domain_name_label   = "big-ip-${random_uuid.big-ip-random-uuid[0].result}-${count.index}"

  tags = {
    environment = var.tag_environment
    resource    = var.tag_resource_type
    owner       = var.tag_owner
  }
}

resource "azurerm_network_interface" "nic-management" {
  name                = "nic-management-${random_uuid.big-ip-random-uuid[0].result}-${count.index}"
  location            = azurerm_resource_group.big-ip-resource-group.location
  resource_group_name = azurerm_resource_group.big-ip-resource-group.name
  count               = sum([var.big-ip-instance-count])

  ip_configuration {
    name                          = "if-config-management-01"
    subnet_id                     = data.azurerm_subnet.existing-subnet-management.id
    private_ip_address_allocation = "Dynamic"
    primary                       = true
    public_ip_address_id          = azurerm_public_ip.public-ip-address-management[count.index].id
  }

  tags = {
    environment = var.tag_environment
    resource    = var.tag_resource_type
    owner       = var.tag_owner
  }
}

resource "azurerm_network_interface" "nic-internal" {
  name                          = "nic-internal-${random_uuid.big-ip-random-uuid[0].result}-${count.index}"
  location                      = azurerm_resource_group.big-ip-resource-group.location
  resource_group_name           = azurerm_resource_group.big-ip-resource-group.name
  count                         = sum([var.big-ip-instance-count])
  enable_ip_forwarding          = true
  enable_accelerated_networking = true

  ip_configuration {
    name                          = "if-config-internal-01"
    subnet_id                     = data.azurerm_subnet.existing-subnet-internal.id
    private_ip_address_allocation = "Dynamic"
    primary                       = true
  }

  ip_configuration {
    name                          = "if-config-internal-02"
    subnet_id                     = data.azurerm_subnet.existing-subnet-internal.id
    private_ip_address_allocation = "Dynamic"
    primary                       = false
  }

  ip_configuration {
    name                          = "if-config-internal-03"
    subnet_id                     = data.azurerm_subnet.existing-subnet-internal.id
    private_ip_address_allocation = "Dynamic"
    primary                       = false
  }

  ip_configuration {
    name                          = "if-config-internal-04"
    subnet_id                     = data.azurerm_subnet.existing-subnet-internal.id
    private_ip_address_allocation = "Dynamic"
    primary                       = false
  }

  ip_configuration {
    name                          = "if-config-internal-05"
    subnet_id                     = data.azurerm_subnet.existing-subnet-internal.id
    private_ip_address_allocation = "Dynamic"
    primary                       = false
  }

  tags = {
    environment = var.tag_environment
    resource    = var.tag_resource_type
    owner       = var.tag_owner
  }
}

resource "azurerm_network_interface" "nic-external" {
  name                          = "nic-external-${random_uuid.big-ip-random-uuid[0].result}-${count.index}"
  location                      = azurerm_resource_group.big-ip-resource-group.location
  resource_group_name           = azurerm_resource_group.big-ip-resource-group.name
  count                         = sum([var.big-ip-instance-count])
  enable_accelerated_networking = true

  ip_configuration {
    name                          = "if-config-external-01"
    subnet_id                     = data.azurerm_subnet.existing-subnet-external.id
    private_ip_address_allocation = "Dynamic"
    primary                       = true
  }

  ip_configuration {
    name                          = "if-config-external-02"
    subnet_id                     = data.azurerm_subnet.existing-subnet-external.id
    private_ip_address_allocation = "Dynamic"
    primary                       = false
  }

  ip_configuration {
    name                          = "if-config-external-03"
    subnet_id                     = data.azurerm_subnet.existing-subnet-external.id
    private_ip_address_allocation = "Dynamic"
    primary                       = false
  }

  ip_configuration {
    name                          = "if-config-external-04"
    subnet_id                     = data.azurerm_subnet.existing-subnet-external.id
    private_ip_address_allocation = "Dynamic"
    primary                       = false
  }

  ip_configuration {
    name                          = "if-config-external-05"
    subnet_id                     = data.azurerm_subnet.existing-subnet-external.id
    private_ip_address_allocation = "Dynamic"
    primary                       = false
  }

  tags = {
    environment = var.tag_environment
    resource    = var.tag_resource_type
    owner       = var.tag_owner
  }
}

## Instances
resource "random_uuid" "big-ip-random-uuid" {
  count = sum([var.big-ip-instance-count])
}

resource "azurerm_virtual_machine" "big-ip-instance" {
  name                         = "big-ip-${random_uuid.big-ip-random-uuid[0].result}-${count.index}"
  location                     = azurerm_resource_group.big-ip-resource-group.location
  resource_group_name          = azurerm_resource_group.big-ip-resource-group.name
  primary_network_interface_id = azurerm_network_interface.nic-management[count.index].id
  network_interface_ids = [
    azurerm_network_interface.nic-management[count.index].id,
    azurerm_network_interface.nic-external[count.index].id,
    azurerm_network_interface.nic-internal[count.index].id

  ]
  vm_size                          = var.big-ip-instance-size
  delete_data_disks_on_termination = true
  delete_os_disk_on_termination    = true
  count                            = sum([var.big-ip-instance-count])

  # az vm image list -p f5-networks --all -f f5-big-ip-best -s 1g-best-hourly
  plan {
    publisher = "f5-networks"
    product   = var.big-ip-instance-offer
    name      = var.big-ip-instance-sku
  }

  storage_image_reference {
    publisher = "f5-networks"
    offer     = var.big-ip-instance-offer
    sku       = var.big-ip-instance-sku
    version   = var.big-ip-version
  }

  storage_os_disk {
    name              = "os-disk-${random_uuid.big-ip-random-uuid[0].result}-${count.index}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "big-ip-${random_uuid.big-ip-random-uuid[0].result}-${count.index}"
    admin_username = var.big-ip-username
    admin_password = var.big-ip-password
    custom_data = base64encode(templatefile("${path.module}/files/bootstrap-big-ip-instances.tpl", {
      package_url    = var.bigip_runtime_init_package_url
      admin_username = var.big-ip-username
    }))
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    environment = var.tag_environment
    resource    = var.tag_resource_type
    owner       = var.tag_owner
  }
}

## Roles

resource "azurerm_role_definition" "bigip-role-definition" {
  name        = "bigip-role-${random_uuid.big-ip-random-uuid[0].result}"
  scope       = data.azurerm_subscription.primary.id
  description = "Role created for BIG-IP clusters"

  permissions {
    actions = [
      "Microsoft.Authorization/*/read",
      "Microsoft.Compute/locations/*/read",
      "Microsoft.Compute/virtualMachines/*/read",
      "Microsoft.Network/*/join/action",
      "Microsoft.Network/networkInterfaces/read",
      "Microsoft.Network/networkInterfaces/write",
      "Microsoft.Network/publicIPAddresses/read",
      "Microsoft.Network/publicIPAddresses/write",
      "Microsoft.Network/routeTables/*/read",
      "Microsoft.Network/routeTables/*/write",
      "Microsoft.Resources/subscriptions/resourceGroups/read",
      "Microsoft.Storage/storageAccounts/listKeys/action",
      "Microsoft.Storage/storageAccounts/read"
    ]
    not_actions = []
  }

  assignable_scopes = [
    data.azurerm_subscription.primary.id
  ]
}

resource "azurerm_role_assignment" "bigip-role-assignment-principal-id" {
  principal_id                     = azurerm_virtual_machine.big-ip-instance[count.index].id
  role_definition_name             = azurerm_role_definition.bigip-role-definition.name
  scope                            = data.azurerm_subscription.primary.id
  skip_service_principal_aad_check = true
  count                            = sum([var.big-ip-instance-count])
}

## Shutdown Schedule
resource "azurerm_dev_test_global_vm_shutdown_schedule" "instance-group-azure-instances" {
  virtual_machine_id    = azurerm_virtual_machine.big-ip-instance[count.index].id
  location              = var.location
  enabled               = true
  daily_recurrence_time = "1900"
  timezone              = "Pacific Standard Time"
  count                 = sum([var.big-ip-instance-count])

  notification_settings {
    enabled         = true
    time_in_minutes = "30"
    email           = var.notification_email
  }
}

## Wait for BIG-IP
resource "time_sleep" "bigip_ready" {
  depends_on      = [azurerm_virtual_machine.big-ip-instance]
  create_duration = var.bigip_ready
}