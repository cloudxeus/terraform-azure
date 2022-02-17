terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">=2.92.0"
    }
  }
}

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

resource "azurerm_app_service_plan" "primary_plan" {
  name                = "primary-plan1000"
  location            = "North Europe"
  resource_group_name = azurerm_resource_group.app_grp.name

  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_app_service" "primary_webapp" {
  name                = "primaryapp1000"
  location            = "North Europe"
  resource_group_name = azurerm_resource_group.app_grp.name
  app_service_plan_id = azurerm_app_service_plan.primary_plan.id
   site_config {    
    dotnet_framework_version = "v6.0"
  }
   source_control {
    repo_url           = "https://github.com/alashro/primaryapp"
    branch             = "master"
    manual_integration = true
    use_mercurial      = false
  }
}

resource "azurerm_app_service_plan" "secondary_plan" {
  name                = "secondary-plan1000"
  location            = "UK South"
  resource_group_name = azurerm_resource_group.app_grp.name

  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_app_service" "secondary_webapp" {
  name                = "secondaryapp1000"
  location            = "UK South"
  resource_group_name = azurerm_resource_group.app_grp.name
  app_service_plan_id = azurerm_app_service_plan.secondary_plan.id
   site_config {    
    dotnet_framework_version = "v6.0"
  }
   source_control {
    repo_url           = "https://github.com/alashro/secondaryapp"
    branch             = "master"
    manual_integration = true
    use_mercurial      = false
  }
}

// Here we are creating a Traffic Manager Profile

resource "azurerm_traffic_manager_profile" "traffic_profile" {
  name                   = "traffic-profile2000"
  resource_group_name    = azurerm_resource_group.app_grp.name
  traffic_routing_method = "Priority"
   dns_config {
    relative_name = "traffic-profile2000"
    ttl           = 100
  }
  monitor_config {
    protocol                     = "https"
    port                         = 443
    path                         = "/"
    interval_in_seconds          = 30
    timeout_in_seconds           = 10
    tolerated_number_of_failures = 2
  }
  }


resource "azurerm_traffic_manager_azure_endpoint" "primary_endpoint" {
  name               = "primary-endpoint"
  profile_id         = azurerm_traffic_manager_profile.traffic_profile.id
  priority           = 1
  weight             = 100
  target_resource_id = azurerm_app_service.primary_webapp.id
}


resource "azurerm_traffic_manager_azure_endpoint" "secondary_endpoint" {
  name               = "secondary-endpoint"
  profile_id         = azurerm_traffic_manager_profile.traffic_profile.id
  priority           = 2
  weight             = 100
  target_resource_id = azurerm_app_service.secondary_webapp.id
}

