################################# Azure BIG-IP Instances #################################

## Azure Network Objects
resource "random_uuid" "pip-mgmt-random-uuid" {
  count = sum([var.big-ip-instance-count])
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
    environment = "Production"
  }
}

resource "azurerm_network_interface" "nic-management" {
  name                = "nic-management-${random_uuid.big-ip-random-uuid[0].result}-${count.index}"
  location            = azurerm_resource_group.big-ip-resource-group.location
  resource_group_name = azurerm_resource_group.big-ip-resource-group.name
  count               = sum([var.big-ip-instance-count])

  ip_configuration {
    name                          = "if-config"
    subnet_id                     = data.azurerm_subnet.existing-subnet-management.id
    private_ip_address_allocation = "Dynamic"
    primary                       = true
    public_ip_address_id          = azurerm_public_ip.public-ip-address-management[count.index].id
  }

  tags = {
    owner = var.tag_owner
  }
}

resource "azurerm_network_interface" "nic-internal" {
  name                 = "nic-internal-${random_uuid.big-ip-random-uuid[0].result}-${count.index}"
  location             = azurerm_resource_group.big-ip-resource-group.location
  resource_group_name  = azurerm_resource_group.big-ip-resource-group.name
  count                = sum([var.big-ip-instance-count])
  enable_ip_forwarding = true

  ip_configuration {
    name                          = "if-config"
    subnet_id                     = data.azurerm_subnet.existing-subnet-internal.id
    private_ip_address_allocation = "Dynamic"
    primary                       = true
  }

  tags = {
    owner = var.tag_owner
  }
}

resource "azurerm_network_interface" "nic-external" {
  name                = "nic-external-${random_uuid.big-ip-random-uuid[0].result}-${count.index}"
  location            = azurerm_resource_group.big-ip-resource-group.location
  resource_group_name = azurerm_resource_group.big-ip-resource-group.name
  count               = sum([var.big-ip-instance-count])

  ip_configuration {
    name                          = "if-config"
    subnet_id                     = data.azurerm_subnet.existing-subnet-external.id
    private_ip_address_allocation = "Dynamic"
    primary                       = true
  }

  tags = {
    owner = var.tag_owner
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

  tags = {
    owner  = var.tag_owner
    big-ip = "instances"
  }
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
    email           = "j.calalang@f5.com"
  }
}

## Wait for BIG-IP
resource "time_sleep" "bigip_ready" {
  depends_on      = [azurerm_virtual_machine.big-ip-instance]
  create_duration = var.bigip_ready
}