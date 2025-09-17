# Configure the provider
provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

terraform {
  required_version = "1.11.4"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.44.0"
    }
  }
}

locals {

  clients = {
    client1 = {
      name = "Client Numero 1"
    }
    bankBankyBank = {
      id = "bbb" # Unique Identifier to ensure storage account name uniqueness
      name = "Bank Banky Bank" # Actual Client Name
      sku  = var.environment == "production" ? "GRS" : "LRS"
    }
  }
}

resource "azurerm_resource_group" "storage_account" {
  name     = "rgp-wd-${var.environment}"
  location = var.location
  tags     = { environment = var.environment }
}

resource "azurerm_storage_account" "storage_account" {
  for_each                 = local.clients
  #Note that the provider will throw an error at plan & apply time if the name is noncompliant, rendering assert expressions moot in this case.
  name                     = lower("sa${each.key}${try(each.value.id, "")}${var.env}") 
  resource_group_name      = azurerm_resource_group.storage_account.name
  location                 = azurerm_resource_group.storage_account.location
  account_tier             = try(each.value.tier, "Standard")
  account_replication_type = try(each.value.sku, "GRS")

  tags = merge({ environment = var.environment }, { client = each.value.name })
}
