output "private_ip" {
  description = "Private IP of the internal Kubernetes API network load balancer (port 6443)."
  value       = oci_network_load_balancer_network_load_balancer.k8s_load_balancer.ip_addresses[0].ip_address
}
