terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "2.92.0"
    }
  }
}

provider "azurerm" {
  subscription_id = "6912d7a0-bc28-459a-9407-33bbba641c07"
  client_id       = "230411ec-45e9-4650-95b2-7675131e2d1a"
  client_secret   = "8D~7Q~y39tBTXsFXGcuVIwvGCOorRUo6dXtwX"
  tenant_id       = "70c0f6d9-7f3b-4425-a6b6-09b47643ec58"
  features {}
}

resource "azurerm_resource_group" "app_grp"{
  name="app-grp" 
  location="North Europe"
}

# Here we are creating a storage account.
# The storage account service has more properties and hence there are more arguements we can specify here

resource "azurerm_storage_account" "storage_account" {
  name                     = "terraformstore10090"
  resource_group_name      = "app-grp"
  location                 = "North Europe"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  allow_blob_public_access = true
}