# Create public IP
resource "azurerm_public_ip" "manage_server" {
  resource_group_name     = var.resource_group_name
  location                = var.resource_group_location
  name                    = "${var.manage_prefix}_PublicIP"
  allocation_method       = "Dynamic"
  sku                     = "Basic"
  domain_name_label       = var.manage_prefix
  idle_timeout_in_minutes = 4
}

# Create network interface
resource "azurerm_network_interface" "manage_server" {
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  name                = "${var.manage_prefix}_NIC"
  ip_configuration {
    name                          = "${var.manage_prefix}_ipconfig1"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.manage_server.id
  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "manage_server" {
  network_interface_id      = azurerm_network_interface.manage_server.id
  network_security_group_id = var.network_security_group_id
}

resource "azurerm_linux_virtual_machine" "manage_server" {
  resource_group_name             = var.resource_group_name
  location                        = var.resource_group_location
  name                            = var.manage_prefix
  network_interface_ids           = [azurerm_network_interface.manage_server.id]
  size                            = var.vms_size
  computer_name                   = var.manage_prefix
  admin_username                  = var.os_profile
  disable_password_authentication = true

  source_image_reference {
    publisher = var.image_reference.publisher
    offer     = var.image_reference.offer
    sku       = var.image_reference.sku
    version   = var.image_reference.version
  }

  os_disk {
    name                 = "${var.manage_prefix}_Disk1"
    caching              = var.storage_os_disk.caching
    storage_account_type = var.storage_os_disk.managed_disk_type
  }
  admin_ssh_key {
    username   = var.os_profile
    public_key = var.public_key
  }
}
