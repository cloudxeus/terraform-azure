// The count meta-arguement helps to create multiple resources 
// without the need of defining multiple resource blocks for each resource

// General block to create the network interface
resource "azurerm_network_interface" "app_interface" {
  count =2

  // The count object is available in expressions. Here the count starts from the number 0
  name                = format("app-interface%s",(count.index)+1)
  location            = azurerm_resource_group.app_grp.location
  resource_group_name = azurerm_resource_group.app_grp.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.SubnetA.id
    private_ip_address_allocation = "Dynamic"    
  }

  depends_on = [
    azurerm_virtual_network.app_network,
    azurerm_subnet.SubnetA
  ]
}



// This is a general resource for the creation of virtual machines
resource "azurerm_windows_virtual_machine" "appvm" {
  count=2  
  name                = format("%s%s",var.vm_details.vm_names,(count.index)+1)
  resource_group_name = azurerm_resource_group.app_grp.name
  location            = azurerm_resource_group.app_grp.location
  size                = "Standard_D2s_v3"
  admin_username      = "demousr"
  admin_password      = "Azure@123"  
  network_interface_ids = [
    azurerm_network_interface.app_interface[count.index].id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }

  depends_on = [
    azurerm_network_interface.app_interface
  ]
}

