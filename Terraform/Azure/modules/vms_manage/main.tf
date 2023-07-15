#################################################################
# Deploy VMs for Manage
#################################################################

# Create public IP
resource "azurerm_public_ip" "manage_servers" {
  depends_on              = [var.resource_group_name]
  count                   = var.vm_count
  resource_group_name     = var.resource_group_name
  location                = var.resource_group_location
  name                    = "${var.manage_prefix}-${count.index + 1}_PublicIP"
  allocation_method       = "Dynamic"
  sku                     = "Basic"
  domain_name_label       = lower("${var.manage_prefix}-${count.index + 1}")
  idle_timeout_in_minutes = 4
}

# Create network interface
resource "azurerm_network_interface" "manage_servers" {
  count               = var.vm_count
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  name                = "${var.manage_prefix}-${count.index + 1}_NIC"
  ip_configuration {
    name                          = "${var.manage_prefix}-${count.index + 1}_ipconfig1"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = element(azurerm_public_ip.manage_servers.*.id, count.index)
  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "manage_servers" {
  count                     = var.vm_count
  network_interface_id      = element(azurerm_network_interface.manage_servers.*.id, count.index)
  network_security_group_id = var.network_security_group_id
}

resource "azurerm_linux_virtual_machine" "manage_servers" {
  count                           = var.vm_count
  resource_group_name             = var.resource_group_name
  location                        = var.resource_group_location
  name                            = "${var.manage_prefix}-${count.index + 1}"
  size                            = var.vms_size
  computer_name                   = "${var.manage_prefix}-${count.index + 1}"
  admin_username                  = var.os_profile
  disable_password_authentication = true
  network_interface_ids           = [element(azurerm_network_interface.manage_servers.*.id, count.index)]

  source_image_reference {
    publisher = var.image_reference.publisher
    offer     = var.image_reference.offer
    sku       = var.image_reference.sku
    version   = var.image_reference.version
  }

  os_disk {
    name                 = "${var.manage_prefix}-${count.index + 1}_Disk1"
    caching              = var.storage_os_disk.caching
    storage_account_type = var.storage_os_disk.managed_disk_type
  }
  admin_ssh_key {
    username   = var.os_profile
    public_key = join("\n", var.public_key)
  }
}
