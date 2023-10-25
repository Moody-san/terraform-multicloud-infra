module "inventory" {
  source           = "./Modules/Inventory_Module"
  oraclek8stemplatepath  = "../ansible-k8s-deployment/templates/oracleinventory.tpl"
  oraclek8sinventorypath = "../ansible-k8s-deployment/inventory/oracleinventory"
  azurek8stemplatepath  = "../ansible-k8s-deployment/templates/azureinventory.tpl"
  azurek8sinventorypath = "../ansible-k8s-deployment/inventory/azureinventory"
  dbtemplatepath  = "../ansible-galeracluster-deployment/templates/inventory.tpl"
  dbinventorypath = "../ansible-galeracluster-deployment/inventory/inventory"
  azureservers    = module.azureservers
  oracleservers   = module.oracleservers
  depends_on = [ module.oracleservers, module.azureservers, module.oci-azure-vpn ]
}


# module "inventory" {
#   source           = "./Modules/Oracle_Inventory_Module"
#   oraclek8stemplatepath  = "../ansible-k8s-deployment/templates/oracleinventory.tpl"
#   oraclek8sinventorypath = "../ansible-k8s-deployment/inventory/oracleinventory"
#   dbtemplatepath  = "../ansible-galeracluster-deployment/templates/inventory.tpl"
#   dbinventorypath = "../ansible-galeracluster-deployment/inventory/inventory"
#   oracleservers   = module.oracleservers
#   depends_on = [ module.oracleservers ]
# }
