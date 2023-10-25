locals {
  oracleservers = [
    {
      display_name = "oraclemaster"
      cpu          = 2
      memory       = 4
      image        = var.oci_ubuntu22_id
      boot_volume  = 50
      assign_public_ip = false
      subnet_id = module.oraclenetwork.ociprivatesubnet_id
    },
    {
      display_name = "oraclemaster2"
      cpu          = 2
      memory       = 4
      image        = var.oci_ubuntu22_id
      boot_volume  = 50
      assign_public_ip = false
      subnet_id = module.oraclenetwork.ociprivatesubnet_id
    },
    {
      display_name = "oraclemaster3"
      cpu          = 2
      memory       = 4
      image        = var.oci_ubuntu22_id
      boot_volume  = 50
      assign_public_ip = false
      subnet_id = module.oraclenetwork.ociprivatesubnet_id
    },
    {
      display_name = "oracleworker"
      cpu          = 2
      memory       = 4
      image        = var.oci_ubuntu22_id
      boot_volume  = 50
      assign_public_ip = false
      subnet_id = module.oraclenetwork.ociprivatesubnet_id
    },
    # {
    #   display_name = "oracledb"
    #   cpu          = 1
    #   memory       = 2
    #   image        = var.oci_ubuntu22_id
    #   boot_volume  = 50
    #   assign_public_ip = false
    #   subnet_id = module.oraclenetwork.ociprivatesubnet_id
    # },
    # {
    #   display_name = "oracledb2"
    #   cpu          = 1
    #   memory       = 2
    #   image        = var.oci_ubuntu22_id
    #   boot_volume  = 50
    #   assign_public_ip = false
    #   subnet_id = module.oraclenetwork.ociprivatesubnet_id
    # },
    {
      display_name = "oraclebastion"
      cpu          = 2
      memory       = 4
      image        = var.oci_ubuntu22_id
      boot_volume  = 50
      assign_public_ip = true
      subnet_id = module.oraclenetwork.ocipublicsubnet_id
    }
  ]
}


variable "azureservers" {
  default = [
    {
      hostname  = "azuremaster"
      diskgb    = 32
      disktype  = "Standard_LRS"
      vm_size   = "Standard_B2s"
      imagetype = "22_04-lts-gen2"
      imagename = "jammy"
    },
    {
      hostname  = "azuremaster2"
      diskgb    = 32
      disktype  = "Standard_LRS"
      vm_size   = "Standard_B2s"
      imagetype = "22_04-lts-gen2"
      imagename = "jammy"
    },
    {
      hostname  = "azuremaster3"
      diskgb    = 32
      disktype  = "Standard_LRS"
      vm_size   = "Standard_B2s"
      imagetype = "22_04-lts-gen2"
      imagename = "jammy"
    },
    {
      hostname  = "azureworker"
      diskgb    = 64
      disktype  = "Premium_LRS"
      vm_size   = "Standard_B2s"
      imagetype = "22_04-lts-gen2"
      imagename = "jammy"
    },
    # {
    #   hostname  = "azuredb"
    #   diskgb    = 64
    #   disktype  = "Premium_LRS"
    #   vm_size   = "Standard_B2s"
    #   imagetype = "22_04-lts-gen2"
    #   imagename = "jammy"
    # },
    # {
    #   hostname  = "azureworker"
    #   diskgb    = 32
    #   disktype  = "Standard_LRS"
    #   vm_size   = "Standard_A2_v2"
    #   imagetype = "22_04-lts"
    #   imagename = "jammy"
    # },
    # {
    #   hostname  = "azureworker2" # db
    #   diskgb    = 64
    #   disktype  = "Premium_LRS"
    #   vm_size   = "Standard_B2s"
    #   imagetype = "20_04-lts-gen2"
    #   imagename = "focal"
    # }
  ]
}