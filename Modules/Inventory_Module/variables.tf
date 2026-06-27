variable "oracleservers" {
  description = "Map of OCI compute module instances (used to build the Ansible inventory groups)."
  type        = any
}

variable "azureservers" {
  description = "Map of Azure compute module instances (used to build the Ansible inventory groups)."
  type        = any
}

variable "oraclek8stemplatepath" {
  description = "Path to the templatefile used to render the Oracle Kubernetes Ansible inventory."
  type        = string
}

variable "oraclek8sinventorypath" {
  description = "Output path for the rendered Oracle Kubernetes Ansible inventory."
  type        = string
}

variable "azurek8stemplatepath" {
  description = "Path to the templatefile used to render the Azure Kubernetes Ansible inventory."
  type        = string
}

variable "azurek8sinventorypath" {
  description = "Output path for the rendered Azure Kubernetes Ansible inventory."
  type        = string
}

variable "dbtemplatepath" {
  description = "Path to the templatefile used to render the Galera/MariaDB Ansible inventory."
  type        = string
}

variable "dbinventorypath" {
  description = "Output path for the rendered Galera/MariaDB Ansible inventory."
  type        = string
}

variable "controllerinventorypath" {
  description = "Output path for the rendered Ansible controller inventory."
  type        = string
}

variable "controllertemplatepath" {
  description = "Path to the templatefile used to render the Ansible controller inventory."
  type        = string
}

locals {
  allservers = {
    ociservers      = [for server in var.oracleservers : server.server_details],
    ocibastionpubip = [for server in var.oracleservers : server.server_details.public_ip if server.server_details.is_oracle_bastion == true] == [] ? ["127.0.0.1"] : [for server in var.oracleservers : server.server_details.public_ip if server.server_details.is_oracle_bastion == true],
    azservers       = [for server in var.azureservers : server.server_details]
    oracleips       = [for server in var.oracleservers : server.server_details.private_ip if server.server_details.is_oracle_bastion == false]
    azureips        = [for server in var.azureservers : server.server_details.private_ip]
  }
}
