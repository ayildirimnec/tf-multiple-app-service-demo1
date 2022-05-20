terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.41.0"
    }
  }
}

provider "azurerm" {
  features  {}
}

terraform {
  backend "azurerm" {}
}

variable app-service-plan-name {
  type        = string
  default     = "necdemoappsvc" 
  description = "Enter the name of the App Service plan"
}

resource "azurerm_resource_group" "rg" {
  name     = "rgmultipleappservicedemo"
  location = "westus2"
}

resource "azurerm_app_service_plan" "app-plan-linux" {
  count = 3   
  name                = "${var.app-service-plan-name}-${count.index}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  kind                = "Linux"
  reserved            = true

  sku {
    tier = "Free"
    size = "F1"
  }
}
