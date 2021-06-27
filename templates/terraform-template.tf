terraform {
  backend "azurerm" {
    resource_group_name   = "tf_rg"
    storage_account_name  = "tfstorageacc01"
    container_name        = "terraform"
    key                   = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "RG" {
  name     = "rl-tf-rg"
  location = "Australia East"
}

resource "azurerm_application_insights" "AppsInsight" {
  name                = "rl-tf-ai"
  location            = azurerm_resource_group.RG.location
  resource_group_name = azurerm_resource_group.RG.name
  application_type    = "web"
}

resource "azurerm_key_vault" "KV" {
  name                = "rl-kv-1"
  location            = azurerm_resource_group.RG.location
  resource_group_name = azurerm_resource_group.RG.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"
}

resource "azurerm_storage_account" "StorageAccount" {
  name                     = "rlstorageacctount1"
  location                 = azurerm_resource_group.RG.location
  resource_group_name      = azurerm_resource_group.RG.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_machine_learning_workspace" "example" {
  name                    = "rl-mlws-1"
  location                = azurerm_resource_group.RG.location
  resource_group_name     = azurerm_resource_group.RG.name
  application_insights_id = azurerm_application_insights.AppsInsight.id
  key_vault_id            = azurerm_key_vault.KV.id
  storage_account_id      = azurerm_storage_account.StorageAccount.id

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_virtual_network" "aml_vnet" {
  name                = "rl-mlws-vnet-1"
  location            = azurerm_resource_group.RG.location
  resource_group_name = azurerm_resource_group.RG.name
  address_space       = ["10.1.0.0/24"]
}

resource "azurerm_subnet" "aml_subnet" {
  name                 = "rl-aml-subnet-1"
  resource_group_name  = azurerm_resource_group.RG.name
  virtual_network_name = azurerm_virtual_network.aml_vnet.name
  address_prefixes     = ["10.1.0.0/28"]
  delegation {
    name = "delegation"
    service_delegation {
      name    = "Microsoft.ContainerInstance/containerGroups"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}