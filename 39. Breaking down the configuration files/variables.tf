// These variables are defined as obejcts

variable "network_details"{    
    description = "This contains all of the network details"
    default={
        network_name="app-network"
        network_address_space="10.0.0.0/16"
        vm_subnet_name="SubnetA"
        vm_subnet_address_space="10.0.0.0/24"
    }
}

variable "vm_details"{

     description = "This contains all of the virtual machine details"
      default={
          vm_names=["appvm1","appvm2"]
      }
}
