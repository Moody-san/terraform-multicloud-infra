variable "vcnname" {
  description = "Name of the Azure virtual network the Application Gateway subnet is created in."
  type        = string
}

variable "rgname" {
  description = "Name of the Azure resource group that hosts the Application Gateway."
  type        = string
}

variable "location" {
  description = "Azure region for the Application Gateway."
  type        = string
}

locals {
  backend_address_pool_name      = "azureapplicationgw-beap"
  frontend_port_name             = "azureapplicationgw-feport"
  frontend_ip_configuration_name = "azureapplicationgw-feip"
  http_setting_name              = "azureapplicationgw-be-htst"
  listener_name                  = "azureapplicationgw-httplstn"
  request_routing_rule_name      = "azureapplicationgw-rqrt"
  redirect_configuration_name    = "azureapplicationgw-rdrcfg"
}

variable "azureservers" {
  description = "Map of Azure compute module instances; worker nodes are selected as Application Gateway backend targets."
  type        = any
}

variable "ssl_password" {
  description = "Password for the PFX SSL certificate (~/ssl/cert.pfx) bound to the Application Gateway HTTPS listener."
  type        = string
  sensitive   = true
}

locals {
  instances = [for instance in var.azureservers : instance.backenddetails.ip_address if length(regexall("worker", instance.backenddetails.server_name)) > 0 ? true : false]
}
