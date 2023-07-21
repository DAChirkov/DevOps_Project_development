output "nic_id" {
  value = azurerm_network_interface.frontend_servers.*.id
}

output "ip_configuration_name" {
  value = [for nic_name in azurerm_network_interface.frontend_servers : nic_name.ip_configuration[0].name]
}
