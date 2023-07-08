terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.63.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "254b8ea5-4f59-43ab-8e86-d247ae4f52c2"
  tenant_id       = "57bfc464-d835-44f7-b99c-cf8de025aadc"
  client_id       = "c02117d8-e5dc-4b6f-a3b4-a3aea2bff685"
  client_secret   = "9O_8Q~dpJAfxnMFhcAvJhyXMCZL_pydZYQf56bhq"
}

resource "azurerm_resource_group" "rg" {
  location = var.resource_group_location
  name     = var.resource_group_name
}

###############################
#ADD SSH KEYS 
###############################

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

resource "azurerm_network_security_group" "main-nsg" {
  depends_on          = [azurerm_resource_group.rg]
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  name                = var.resource_main-nsg
}
resource "azurerm_network_security_rule" "main-nsg-ssh" {
  depends_on                  = [azurerm_network_security_group.main-nsg]
  name                        = "SSH"
  resource_group_name         = var.resource_group_name
  network_security_group_name = var.resource_main-nsg
  priority                    = 1000
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "178.134.247.73"
  destination_address_prefix  = "10.1.0.4"
}
resource "azurerm_network_security_rule" "main-nsg-http" {
  depends_on                  = [azurerm_network_security_group.main-nsg]
  name                        = "SiteAllow_HTTP"
  resource_group_name         = var.resource_group_name
  network_security_group_name = var.resource_main-nsg
  priority                    = 999
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "10.1.1.0/24"
}
