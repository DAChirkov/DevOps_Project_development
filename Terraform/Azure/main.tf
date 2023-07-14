terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.63.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "RG_AzProject"
    storage_account_name = "tfstate1748524386"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  location = var.resource_group_location
  name     = var.resource_group_name
}

resource "azurerm_ssh_public_key" "ssh_servers_key" {
  depends_on          = [azurerm_resource_group.rg]
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  name                = var.resource_ssh_servers_key
  public_key          = var.resource_ssh_servers_public_key
}
resource "azurerm_ssh_public_key" "ssh_clients_key" {
  depends_on          = [azurerm_resource_group.rg]
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  name                = var.resource_ssh_clients_key
  public_key          = var.resource_ssh_clients_public_key
}


resource "azurerm_virtual_network" "vnet" {
  depends_on          = [azurerm_resource_group.rg]
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  name                = var.resource_virtual_network
  address_space       = ["10.1.0.0/16"]
}
resource "azurerm_subnet" "snet1" {
  depends_on           = [azurerm_virtual_network.vnet]
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.resource_virtual_network
  name                 = var.resource_subnet1
  address_prefixes     = ["10.1.0.0/24"]
}
resource "azurerm_subnet" "snet2" {
  depends_on           = [azurerm_virtual_network.vnet]
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.resource_virtual_network
  name                 = var.resource_subnet2
  address_prefixes     = ["10.1.1.0/24"]
}
resource "azurerm_subnet" "snet3" {
  depends_on           = [azurerm_virtual_network.vnet]
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.resource_virtual_network
  name                 = var.resource_subnet3
  address_prefixes     = ["10.1.2.0/24"]
}

resource "azurerm_network_security_group" "nsg_main" {
  depends_on          = [azurerm_resource_group.rg]
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  name                = var.resource_nsg_main
}
resource "azurerm_network_security_rule" "nsg_main_ssh" {
  depends_on                  = [azurerm_network_security_group.nsg_main]
  name                        = "SSH"
  resource_group_name         = var.resource_group_name
  network_security_group_name = var.resource_nsg_main
  priority                    = 1000
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "178.134.247.73"
  destination_address_prefix  = "10.1.0.4"
}
resource "azurerm_network_security_rule" "nsg_main_http" {
  depends_on                  = [azurerm_network_security_group.nsg_main]
  name                        = "SiteAllow_HTTP"
  resource_group_name         = var.resource_group_name
  network_security_group_name = var.resource_nsg_main
  priority                    = 999
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "10.1.1.0/24"
}

# VM for manage
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
  name                = "${var.manage_prefix}_nic"
  ip_configuration {
    name                          = "${var.manage_prefix}_ipconfig1"
    subnet_id                     = azurerm_subnet.snet1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.manage_server.id
  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "manage_server" {
  network_interface_id      = azurerm_network_interface.manage_server.id
  network_security_group_id = azurerm_network_security_group.nsg_main.id
}

resource "azurerm_linux_virtual_machine" "manage_server" {
  depends_on = [
    azurerm_resource_group.rg,
    azurerm_ssh_public_key.ssh_servers_key
  ]
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
    name                 = "${var.manage_prefix}_disk1"
    caching              = var.storage_os_disk.caching
    storage_account_type = var.storage_os_disk.managed_disk_type
  }
  admin_ssh_key {
    username   = var.os_profile
    public_key = azurerm_ssh_public_key.ssh_servers_key.public_key
  }
}
