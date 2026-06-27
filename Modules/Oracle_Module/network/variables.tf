#Network variables
variable "vcn" {
  description = "Name and CIDR block for the OCI VCN."
  type = object({
    name = string
    cidr = string
  })
  default = {
    name = "vcn"
    cidr = "10.0.0.0/16"
  }
}

variable "internet_gateway" {
  description = "Display name and default-route destination for the internet gateway."
  type = object({
    name           = string
    destination_ip = string
  })
  default = {
    name           = "igw"
    destination_ip = "0.0.0.0/0"
  }
}

variable "nat_gateway" {
  description = "Display name and default-route destination for the NAT gateway."
  type = object({
    name           = string
    destination_ip = string
  })
  default = {
    name           = "ngw"
    destination_ip = "0.0.0.0/0"
  }
}

variable "privatesubnet" {
  description = "Name and CIDR for the private subnet that hosts the workload instances."
  type = object({
    name = string
    ip   = string
  })
  default = {
    name = "privatesubnet",
    ip   = "10.0.1.0/24"
  }
}

variable "pubsubnet" {
  description = "Name and CIDR for the first public subnet (AD3)."
  type = object({
    name = string
    ip   = string
  })
  default = {
    name = "pubsubnet",
    ip   = "10.0.3.0/24"
  }
}

variable "pubsubnet2" {
  description = "Name and CIDR for the second public subnet (AD2), required for the public load balancer."
  type = object({
    name = string
    ip   = string
  })
  default = {
    name = "pubsubnet2",
    ip   = "10.0.5.0/24"
  }
}


variable "egress_rules" {
  description = "Protocol and destination CIDR for the security-list egress rule."
  type = object({
    protocol    = string
    destination = string
  })
  default = {
    protocol    = "all"
    destination = "0.0.0.0/0"
  }
}

variable "ingress_rules" {
  description = "Protocol and source CIDR for the security-list ingress rule."
  type = object({
    protocol = string
    source   = string
  })
  default = {
    protocol = "all"
    source   = "0.0.0.0/0"
  }
}

variable "compartment_id" {
  description = "OCID of the compartment that owns the network resources."
  type        = string
}

variable "AD" {
  description = "Primary availability domain for subnets/instances."
  type        = string
}

variable "AD2" {
  description = "Second availability domain, used for the secondary public subnet."
  type        = string
}

variable "azure_ipcidr" {
  description = "Azure network CIDR routed over the DRG/VPN from the OCI route tables."
  type        = string
  default     = "192.0.0.0/16"
}
