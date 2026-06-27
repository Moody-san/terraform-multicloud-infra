output "public_ip" {
  description = "Public IP of the Azure Application Gateway fronting the worker NodePort (HTTPS 443)."
  value       = azurerm_public_ip.publiclbip.ip_address
}
