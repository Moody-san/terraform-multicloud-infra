variable "vm_size" {
  description = "Azure VM SKU/size for the instance."
  type        = string
  default     = "Standard_B1s"
}

variable "username" {
  description = "Admin username configured on the VM (also used as the SSH user)."
  type        = string
  default     = "ubuntu"
}

variable "hostname" {
  description = "Hostname / computer name of the VM; also drives the NIC and disk names."
  type        = string
  default     = "server"
}

locals {
  source_image_reference = {
    offer     = "0001-com-ubuntu-server-${var.imagename}"
    publisher = "Canonical"
    version   = "latest"
  }
}

variable "os_disk" {
  description = "OS disk configuration (name suffix and caching mode)."
  type = object({
    name    = string
    caching = string
  })
  default = {
    name    = "osdisk"
    caching = "ReadWrite"
  }
}

variable "diskstoragetype" {
  description = "Managed disk storage account type for the OS disk (e.g. Standard_LRS, Premium_LRS)."
  type        = string
  default     = "Standard_LRS"
}

variable "diskstoragegbs" {
  description = "OS disk size in GB."
  type        = number
  default     = 32
}

variable "eviction_policy" {
  description = "Eviction policy for Spot VMs (Delete or Deallocate)."
  type        = string
  default     = "Delete"
}

variable "priority" {
  description = "VM priority. Set to Spot for spot instances; comment the priority/max_bid_price lines for a regular VM."
  type        = string
  default     = "Spot"
}

variable "max_bid_price" {
  description = "Maximum hourly price (USD) for a Spot VM; -1 means pay up to the on-demand price."
  type        = number
  default     = 0.011
}

variable "location" {
  description = "Azure region where the VM is deployed."
  type        = string
}

variable "rgname" {
  description = "Name of the Azure resource group that hosts the VM."
  type        = string
}

variable "subnet_id" {
  description = "ID of the subnet the VM's NIC is attached to."
  type        = string
}

variable "imagetype" {
  description = "Image SKU (e.g. 22_04-lts-arm64) used for the source image reference."
  type        = string
}

variable "ssh_key" {
  description = "Path to the SSH public key file authorised on the VM."
  type        = string
}

variable "imagename" {
  description = "Ubuntu image codename used to build the marketplace offer (e.g. jammy)."
  type        = string
}
