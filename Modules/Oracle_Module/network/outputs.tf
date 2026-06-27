output "ociprivatesubnet_id" {
  description = "OCID of the private subnet that hosts the workload instances."
  value       = oci_core_subnet.privatesubnet.id
}

output "ocipublicsubnet_id" {
  description = "OCID of the first public subnet (AD3)."
  value       = oci_core_subnet.pubsubnet.id
}

output "ocipublicsubnet2_id" {
  description = "OCID of the second public subnet (AD2), used by the public load balancer."
  value       = oci_core_subnet.pubsubnet2.id
}

output "ocidrgid" {
  description = "OCID of the Dynamic Routing Gateway, consumed by the VPN module for the IPSec attachment."
  value       = oci_core_drg.drg.id
}
