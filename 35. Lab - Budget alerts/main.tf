terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "2.93.0"
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



// We need to define the action group
resource "azurerm_monitor_action_group" "email_alert" {
  name                = "email-alert"
  resource_group_name = azurerm_resource_group.app_grp.name
  short_name          = "email-alert"

   email_receiver {
    name                    = "sendtoAdmin"
    email_address           = ""
    use_common_alert_schema = true
  }

}

resource "azurerm_consumption_budget_resource_group" "Monthly_budget" {
  name              = "Monthly-budget"
  resource_group_id = azurerm_resource_group.app_grp.id

  amount     = 50
  time_grain = "Monthly"

  time_period {
    start_date = "2022-02-01T00:00:00Z"
    end_date   = "2022-12-01T00:00:00Z"
  }

    notification {
    enabled        = true
    threshold      = 70.0
    operator       = "EqualTo"
    threshold_type = "Forecasted"

    
    contact_groups = [
      azurerm_monitor_action_group.email_alert.id,
    ]
    }
}