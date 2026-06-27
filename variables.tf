variable "ssh_key" {
  description = "Path to the SSH public key file injected into every provisioned instance (OCI and Azure)."
  type        = string
}

variable "oci_compartment_id" {
  description = "OCID of the OCI compartment in which all Oracle Cloud resources are created."
  type        = string
}

variable "oci_ubuntu22_id" {
  description = "OCID of the Ubuntu 22.04 (ARM64) image used for all OCI compute instances."
  type        = string
  default     = "ocid1.image.oc1.phx.aaaaaaaa327eqiyphdvv4imkbpjcrhsf543cfmx3bttxzfu7tmae4kk7kqua"
}

variable "az_subscription_id" {
  description = "Azure subscription ID for the service principal used by the azurerm provider."
  type        = string
  sensitive   = true
}

variable "az_client_id" {
  description = "Azure service principal (application) client ID used by the azurerm provider."
  type        = string
  sensitive   = true
}

variable "az_client_secret" {
  description = "Azure service principal client secret used by the azurerm provider."
  type        = string
  sensitive   = true
}

variable "az_tenant_id" {
  description = "Azure Active Directory tenant ID for the service principal."
  type        = string
  sensitive   = true
}

variable "ssl_password" {
  description = "Password protecting the Azure Application Gateway PFX certificate (~/ssl/cert.pfx)."
  type        = string
  sensitive   = true
}
