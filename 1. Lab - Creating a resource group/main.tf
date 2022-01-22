# We first specify the terraform provider. 
# Terraform will use the provider to ensure that we can work with Microsoft Azure

terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "2.92.0"
    }
  }
}

# Here we need to mention the Azure AD Application Object credentials to allow us to work with 
# our Azure account

provider "azurerm" {
  subscription_id = "6912d7a0-bc28-459a-9407-33bbba641c07"
  client_id       = "230411ec-45e9-4650-95b2-7675131e2d1a"
  client_secret   = "8D~7Q~y39tBTXsFXGcuVIwvGCOorRUo6dXtwX"
  tenant_id       = "70c0f6d9-7f3b-4425-a6b6-09b47643ec58"
  features {}
}

# The resource block defines the type of resource we want to work with
# The name and location are arguements for the resource block

resource "azurerm_resource_group" "app_grp"{
  name="app-grp" 
  location="North Europe"
}
