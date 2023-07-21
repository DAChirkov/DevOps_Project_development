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

resource "azurerm_availability_set" "av_set_frontend" {
  depends_on                   = [azurerm_resource_group.rg]
  resource_group_name          = var.resource_group_name
  location                     = var.resource_group_location
  name                         = var.resource_availability_set_frontend
  platform_fault_domain_count  = 2
  platform_update_domain_count = 2
  managed                      = true
}
resource "azurerm_availability_set" "av_set_backend" {
  depends_on                   = [azurerm_resource_group.rg]
  resource_group_name          = var.resource_group_name
  location                     = var.resource_group_location
  name                         = var.resource_availability_set_backend
  platform_fault_domain_count  = 2
  platform_update_domain_count = 2
  managed                      = true
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
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "10.1.0.4"
}
resource "azurerm_network_security_rule" "nsg_main_http" {
  depends_on                  = [azurerm_network_security_group.nsg_main]
  name                        = "HTTP"
  resource_group_name         = var.resource_group_name
  network_security_group_name = var.resource_nsg_main
  priority                    = 101
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "10.1.1.0/24"
}

# Load Balancer
resource "azurerm_public_ip" "lb" {
  depends_on          = [azurerm_resource_group.rg]
  name                = var.resource_lb_ip
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  allocation_method   = "Dynamic"
  sku                 = "Basic"
  domain_name_label   = lower(var.resource_lb_ip_dnsname)
}
resource "azurerm_lb" "lb" {
  resource_group_name = var.resource_group_name
  name                = var.resource_lb_ip_dnsname
  location            = var.resource_group_location

  frontend_ip_configuration {
    name                 = var.resource_front_ip_name
    public_ip_address_id = azurerm_public_ip.lb.id
  }
}
resource "azurerm_lb_backend_address_pool" "backend_pool" {
  loadbalancer_id = azurerm_lb.lb.id
  name            = var.resource_backendpool_name
}
resource "azurerm_network_interface_backend_address_pool_association" "backend_pool" {
  count                   = var.count_vms_frontend
  backend_address_pool_id = azurerm_lb_backend_address_pool.backend_pool.id
  ip_configuration_name   = element(module.frontend_vms.ip_configuration_name, count.index)
  network_interface_id    = module.frontend_vms.nic_id[count.index]
}

resource "azurerm_lb_rule" "lb_rule" {
  loadbalancer_id                = azurerm_lb.lb.id
  name                           = var.resource_lbrule_name
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = var.resource_front_ip_name
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.backend_pool.id]
  enable_floating_ip             = false
  idle_timeout_in_minutes        = 4
  probe_id                       = azurerm_lb_probe.lb_probe.id
  depends_on                     = [azurerm_lb_probe.lb_probe]
}
resource "azurerm_lb_probe" "lb_probe" {
  loadbalancer_id     = azurerm_lb.lb.id
  name                = "Probe_HTTP"
  protocol            = "Tcp"
  port                = 80
  interval_in_seconds = 5
  number_of_probes    = 2
}

#####################################################

module "vms_for_manage" {
  vm_count                  = var.count_vms_manage
  source                    = "./modules/vms_manage"
  resource_group_name       = azurerm_resource_group.rg.name
  resource_group_location   = azurerm_resource_group.rg.location
  subnet_id                 = azurerm_subnet.snet1.id
  network_security_group_id = azurerm_network_security_group.nsg_main.id
  public_key = [
    azurerm_ssh_public_key.ssh_servers_key.public_key,
    azurerm_ssh_public_key.ssh_clients_key.public_key
  ]
}

module "frontend_vms" {
  vm_count                  = var.count_vms_frontend #default - 2, need to change LB parameters & Ansible configs
  source                    = "./modules/vms_frontend"
  resource_group_name       = azurerm_resource_group.rg.name
  resource_group_location   = azurerm_resource_group.rg.location
  subnet_id                 = azurerm_subnet.snet2.id
  network_security_group_id = azurerm_network_security_group.nsg_main.id
  availability_set_id       = azurerm_availability_set.av_set_frontend.id
  public_key                = azurerm_ssh_public_key.ssh_clients_key.public_key
}

module "backend_vms" {
  vm_count                  = var.count_vms_backend #default - 2, need to change Ansible & Nginx configs
  source                    = "./modules/vms_backend"
  resource_group_name       = azurerm_resource_group.rg.name
  resource_group_location   = azurerm_resource_group.rg.location
  subnet_id                 = azurerm_subnet.snet3.id
  network_security_group_id = azurerm_network_security_group.nsg_main.id
  availability_set_id       = azurerm_availability_set.av_set_backend.id
  public_key                = azurerm_ssh_public_key.ssh_clients_key.public_key
}
