# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0.1"
    }
  }

  required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription-id
}

# Resource Groupの作成
resource "azurerm_resource_group" "rg" {
  name     = "${var.global-name}-rg"
  location = "Japan East"
}

# Storage Accountの作成（Function用）
resource "azurerm_storage_account" "storage" {
  name                     = "${var.global-name}st"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_kind             = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# Service Planの作成 (Function用)
resource "azurerm_service_plan" "service-plan" {
  name                = "${var.global-name}-service-plan"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  os_type             = "Linux"
  sku_name            = "Y1"
}

# Function Appの作成
resource "azurerm_linux_function_app" "function" {
  name                       = "${var.global-name}-function"
  resource_group_name        = azurerm_resource_group.rg.name
  location                   = azurerm_resource_group.rg.location
  storage_account_name       = azurerm_storage_account.storage.name
  storage_account_access_key = azurerm_storage_account.storage.primary_access_key
  service_plan_id            = azurerm_service_plan.service-plan.id

  site_config {
    application_stack {
      python_version = "3.9"
    }
  }

  app_settings = {
    "FUNCTIONS_WORKER_RUNTIME" = "python"
  }
}

# API Managementの作成
resource "azurerm_api_management" "api-management" {
  name                = "${var.global-name}-api-management"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  publisher_name      = "MetalMental"
  publisher_email     = "flupino@metalmental.net"
  sku_name            = "Developer_1"
}

# REST APIの作成
resource "azurerm_api_management_api" "rest-api" {
  name                = "${var.global-name}-rest-api"
  api_management_name = azurerm_api_management.api-management.name
  resource_group_name = azurerm_resource_group.rg.name
  revision            = "1"
  display_name        = "RESTAPI"
  path                = "restapi"
  protocols           = ["http", "https"]

  import {
    content_format = "openapi"
    content_value  = file("${path.module}/api_definition.yaml")
  }
  depends_on = [azurerm_resource_group.rg]
}

# # Azure OpenAIリソースの作成
# resource "azurerm_cognitive_account" "openai" {
#   name                = "${var.global-name}-openai"
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name
#   kind                = "OpenAI"

#   sku_name = "S0"

#   custom_subdomain_name = "${var.global-name}-openai"

#   tags = {
#     environment = "production"
#   }
# }

# # OpenAIモデルのデプロイメント
# resource "azurerm_cognitive_deployment" "gpt_deployment" {
#   name                 = "gpt-35-turbo"
#   cognitive_account_id = azurerm_cognitive_account.openai.id

#   model {
#     format  = "OpenAI"
#     name    = "gpt-35-turbo"
#     version = "0301"
#   }

#   scale {
#     type = "Standard"
#   }
# }