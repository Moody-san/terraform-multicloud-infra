variable "compartment_ocid" {
  description = "OCID of the compartment that owns the internal Kubernetes network load balancer."
  type        = string
}

variable "subnet_id" {
  description = "OCID of the private subnet the network load balancer is attached to."
  type        = string
}

variable "oracleservers" {
  description = "Map of OCI compute module instances; master nodes are registered as NLB backends on port 6443."
  type        = any
}

locals {
  instances = [for instance in var.oracleservers : instance.backenddetails if length(regexall("master", instance.backenddetails.server_name)) > 0 ? true : false]
}
