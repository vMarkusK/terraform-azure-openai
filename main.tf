terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.31.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = ">= 3.3"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.7"
    }
    time = {
      source  = "hashicorp/time"
      version = ">= 0.13"
    }
    http = {
      source  = "hashicorp/http"
      version = ">= 3.5"
    }
  }
  backend "azurerm" {}
  required_version = "~> 1.12.0"
}

provider "azurerm" {
  features {}
  subscription_id                 = var.subscription_id
  resource_provider_registrations = "core"
  storage_use_azuread             = true
}

resource "azurerm_resource_group" "this" {
  name     = local.rg_name
  location = var.location
}