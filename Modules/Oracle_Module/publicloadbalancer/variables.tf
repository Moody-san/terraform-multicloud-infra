variable "compartment_ocid" {
  description = "OCID of the compartment that owns the public load balancer."
  type        = string
}

variable "subnet_id" {
  description = "OCID of the first public subnet the load balancer is attached to."
  type        = string
}

variable "subnet2_id" {
  description = "OCID of the second public subnet (different AD) the load balancer is attached to."
  type        = string
}

variable "oracleservers" {
  description = "Map of OCI compute module instances; worker nodes are registered as backends on the NodePort (31736)."
  type        = any
}

locals {
  instances = [for instance in var.oracleservers : instance.backenddetails if length(regexall("worker", instance.backenddetails.server_name)) > 0]
}
