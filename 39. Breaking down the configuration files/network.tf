resource "azurerm_virtual_network" "app_network" {
  name                = var.network_details.network_name
  location            = local.location
  resource_group_name = azurerm_resource_group.app_grp.name
  address_space       = [var.network_details.network_address_space]  
  depends_on = [
    azurerm_resource_group.app_grp
  ]
}

resource "azurerm_subnet" "SubnetA" {
  name                 = var.network_details.vm_subnet_name
  resource_group_name  = azurerm_resource_group.app_grp.name
  virtual_network_name = azurerm_virtual_network.app_network.name
  address_prefixes     = [ var.network_details.vm_subnet_address_space]
  depends_on = [
    azurerm_virtual_network.app_network
  ]
}
