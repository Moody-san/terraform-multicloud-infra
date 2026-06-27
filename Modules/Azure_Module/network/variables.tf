variable "region" {
  description = "Azure region for the resource group and all networking resources."
  type        = string
  default     = "westus3"
}

variable "cidr_ip_block" {
  description = "Address space (CIDR) for the Azure virtual network."
  type        = string
  default     = "192.0.0.0/16"
}

variable "privatesubnetip" {
  description = "CIDR block for the private subnet that hosts the workload VMs."
  type        = string
  default     = "192.0.1.0/24"
}
