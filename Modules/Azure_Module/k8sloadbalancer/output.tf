output "private_ip" {
  description = "Private frontend IP of the internal Kubernetes API load balancer (port 6443)."
  value       = azurerm_lb.k8slb.private_ip_address
}
