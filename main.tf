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

#variable app-service-plan-name {
#  type        = string
#  default     = "${var.environment}necdemoappsvc" 
#  description = "Enter the name of the App Service plan"
#}

resource "azurerm_resource_group" "rg" {
  name     = "${var.targetenvironmet}rgmultipleappservicedemo"
  location = "australiaeast"
}

resource "azurerm_app_service_plan" "app-plan-linux" {  
  name                = "${var.targetenvironmet}necdemoappsvcplan"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  kind                = "Linux"
  reserved            = true

  sku {
    tier = "Free"
    size = "F1"
  }
}

resource "azurerm_app_service" "example" {
  count = 3
  name                = "${var.targetenvironmet}-app-service${count.index}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  app_service_plan_id = azurerm_app_service_plan.app-plan-linux.id

  app_settings = {
    "SOME_KEY" = "some-value"
  }
}

