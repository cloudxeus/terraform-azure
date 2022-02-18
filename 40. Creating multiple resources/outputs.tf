output "private_ip_address" {
description ="Here the private IP addresses assigned to the VM's will be shown"
value= {
    for ip in azurerm_network_interface.app_interface:
    ip.name=>ip.private_ip_address
}
}