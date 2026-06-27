variable "oraclenetworkcidr" {
  description = "OCI VCN CIDR advertised to Azure as the local network gateway address space."
  type        = string
  default     = "10.0.0.0/16"
}

variable "azuregatewaysubnetcidr" {
  description = "CIDR for the Azure GatewaySubnet that hosts the Virtual Network Gateway."
  type        = string
  default     = "192.0.0.0/24"
}

variable "drgid" {
  description = "OCID of the OCI Dynamic Routing Gateway the IPSec connection attaches to."
  type        = string
}

variable "ocicompartment_id" {
  description = "OCID of the compartment that owns the OCI CPE and IPSec connection."
  type        = string
}

variable "azurelocation" {
  description = "Azure region for the VPN gateway, public IP and connections."
  type        = string
}

variable "azurergname" {
  description = "Name of the Azure resource group hosting the VPN gateway resources."
  type        = string
}

variable "azurevcnname" {
  description = "Name of the Azure virtual network the GatewaySubnet is created in."
  type        = string
}
