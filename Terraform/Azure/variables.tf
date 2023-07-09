variable "resource_group_location" {
  default     = "eastus2"
  description = "Location of the resource group"
}

variable "resource_group_name" {
  default     = "RG_AzProject_VMs"
  description = "Name of the resource group"
}

variable "resource_ssh_clients_key" {
  default     = "SSHKeysForClients"
  description = "Name of the SSH keys for clients"
}

variable "resource_virtual_network" {
  default     = "vNet-AzProject"
  description = "Name of the virtual network"
}
variable "resource_subnet1" {
  default     = "SubNet1-AzProject"
  description = "Name of the subnet 1"
}
variable "resource_subnet2" {
  default     = "SubNet2-AzProject"
  description = "Name of the subnet 2"
}
variable "resource_subnet3" {
  default     = "SubNet3-AzProject"
  description = "Name of the subnet 3"
}
variable "resource_nsg_main" {
  default     = "NSG-AzProject"
  description = "Name of the main NSG"
}
