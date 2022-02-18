provider "azurerm" {
  subscription_id = "6912d7a0-bc28-459a-9407-33bbba641c07"
  client_id       = "7048caf3-327c-4b70-9461-e47683ec9b6f"
  client_secret   = "BkK7Q~mxpNI4TIH-eb7B9oGvx6ntABH~L-iQn"
  tenant_id       = "70c0f6d9-7f3b-4425-a6b6-09b47643ec58"
  features {}
}


locals {
  resource_group="app-grp"
  location="North Europe"  
}


resource "azurerm_resource_group" "app_grp"{
  name=local.resource_group
  location=local.location
}



