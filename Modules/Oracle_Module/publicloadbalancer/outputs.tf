output "public_ip" {
  description = "Public IP of the OCI load balancer fronting the worker NodePort (HTTPS 443)."
  value       = oci_load_balancer_load_balancer.public_load_balancer.ip_address_details[0].ip_address
}
