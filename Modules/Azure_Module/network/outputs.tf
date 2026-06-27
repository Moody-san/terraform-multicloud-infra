output "location" {
  description = "Azure region of the resource group."
  value       = azurerm_resource_group.azurerg.location
}

output "name" {
  description = "Name of the Azure resource group."
  value       = azurerm_resource_group.azurerg.name
}

output "azureprivatesubnet_id" {
  description = "ID of the private subnet that hosts the workload VMs."
  value       = azurerm_subnet.privatesubnet.id
}

output "vcnname" {
  description = "Name of the Azure virtual network."
  value       = azurerm_virtual_network.azurevcn.name
}

output "azurevnet_id" {
  description = "ID of the Azure virtual network."
  value       = azurerm_virtual_network.azurevcn.id
}
