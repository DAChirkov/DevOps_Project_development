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
variable "resource_ssh_clients_public_key" {
  type    = string
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCzWbMptvM+o3kEEbxv/p0SEIYDUJ4S5hiKweErOAUH15NFU6mULq9qnb1CqZmwIFaYT+TNEDWhIwLdGlCK6HEoU1cB8saA4t7FDZcWHlkR0V0TuHF+ikrH+Q1Iu9qza3ieXsWflLhY9T6xUqdrTbNv4y215+Pu4SyAJtCOM9Ly0zOEbFuNUmc95711HIwljF32/cxO7bZyjeSmmBqRhlz08SR+7bo94+48Gw807Yi+xS7kMa8WoUwcTuAhur3xHjc2nxDdUz3E9OzC0M22Yya/vBgixwhy7cFq/I2GZiIpPeCdyHNh9UWQh9AN9pMPqohCp/qQ08bao+R8aGzHOyIl Azure_Project_Cl_20230605"
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
