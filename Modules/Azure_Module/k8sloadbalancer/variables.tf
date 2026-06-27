variable "rgname" {
  description = "Name of the Azure resource group that hosts the internal load balancer."
  type        = string
}

variable "subnet_id" {
  description = "ID of the subnet for the load balancer's private frontend IP."
  type        = string
}

variable "location" {
  description = "Azure region for the load balancer."
  type        = string
}

variable "azureservers" {
  description = "Map of Azure compute module instances; master nodes are selected as backend pool members."
  type        = any
}

variable "azurevnetid" {
  description = "ID of the virtual network used when registering backend pool addresses."
  type        = string
}

locals {
  instances = [for instance in var.azureservers : instance.backenddetails if length(regexall("master", instance.backenddetails.server_name)) > 0 ? true : false]
}
