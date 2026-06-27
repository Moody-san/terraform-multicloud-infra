module "azurenetwork" {
  source = "./Modules/Azure_Module/network"
  providers = {
    azurerm = azurerm.azure_st
  }
}

module "azureservers" {
  providers = {
    azurerm = azurerm.azure_st
  }
  source          = "./Modules/Azure_Module/compute"
  for_each        = { for server in var.azureservers : server.hostname => server }
  hostname        = each.value.hostname
  diskstoragegbs  = each.value.diskgb
  diskstoragetype = each.value.disktype
  vm_size         = each.value.vm_size
  imagetype       = each.value.imagetype
  ssh_key         = var.ssh_key
  location        = module.azurenetwork.location
  rgname          = module.azurenetwork.name
  subnet_id       = module.azurenetwork.azureprivatesubnet_id
  imagename       = each.value.imagename
  depends_on      = [module.azurenetwork]
}


module "k8sazurelb" {
  source = "./Modules/Azure_Module/k8sloadbalancer"
  providers = {
    azurerm = azurerm.azure_st
  }
  subnet_id    = module.azurenetwork.azureprivatesubnet_id
  location     = module.azurenetwork.location
  rgname       = module.azurenetwork.name
  azureservers = module.azureservers
  azurevnetid  = module.azurenetwork.azurevnet_id
  depends_on   = [module.azureservers]
}

output "azure_k8slb_private_ip" {
  description = "Private IP of the internal Azure load balancer fronting the Kubernetes API (port 6443)."
  value       = module.k8sazurelb.private_ip
}

module "azurepubliclb" {
  source = "./Modules/Azure_Module/publicloadbalancer"
  providers = {
    azurerm = azurerm.azure_st
  }
  location     = module.azurenetwork.location
  rgname       = module.azurenetwork.name
  vcnname      = module.azurenetwork.vcnname
  ssl_password = var.ssl_password
  azureservers = module.azureservers
  depends_on   = [module.azureservers]
}

output "azurepubliclb_publicip" {
  description = "Public IP of the Azure Application Gateway fronting the worker NodePort."
  value       = module.azurepubliclb.public_ip
}

output "azure_servers" {
  description = "Name and IP of every provisioned Azure VM."
  value       = [for server in module.azureservers : server.output_ips]
}

