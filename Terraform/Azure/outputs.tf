output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}
output "resource_virtual_network" {
  value = [azurerm_virtual_network.vnet.name, azurerm_virtual_network.vnet.address_space]
}
output "resource_subnet1" {
  value = [azurerm_subnet.snet1.name, azurerm_subnet.snet1.address_prefixes]
}
output "resource_subnet2" {
  value = [azurerm_subnet.snet2.name, azurerm_subnet.snet2.address_prefixes]
}
output "resource_subnet3" {
  value = [azurerm_subnet.snet3.name, azurerm_subnet.snet3.address_prefixes]
}
output "resource_main-nsg" {
  value = azurerm_network_security_group.main-nsg.name
}
