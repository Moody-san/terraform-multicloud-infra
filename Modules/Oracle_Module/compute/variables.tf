#Compute Variables

variable "vm_shape" {
  description = "OCI compute shape (defaults to the Ampere A1 Flex ARM shape)."
  type        = string
  default     = "VM.Standard.A1.Flex"
}

variable "assign_public_ip" {
  description = "Whether the instance VNIC should receive a public IP (true for bastion/jenkins/argocd, false for private nodes)."
  type        = bool
  default     = false
}

variable "boot_volume" {
  description = "Boot volume size in GB."
  type        = number
}

variable "cpu" {
  description = "Number of OCPUs allocated to the flexible shape."
  type        = number
}

variable "memory" {
  description = "Memory in GB allocated to the flexible shape."
  type        = number
}

variable "server_name" {
  description = "Display name and hostname label of the instance; drives the master/worker/db/bastion role."
  type        = string
}

variable "ssh_key" {
  description = "Path to the SSH public key file authorised on the instance."
  type        = string
}

variable "AD" {
  description = "OCI availability domain in which the instance is launched."
  type        = string
}

variable "compartment_id" {
  description = "OCID of the compartment that owns the instance."
  type        = string
}

variable "subnet_id" {
  description = "OCID of the subnet the instance VNIC is attached to."
  type        = string
}

variable "image_id" {
  description = "OCID of the boot image for the instance."
  type        = string
}
