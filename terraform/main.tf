resource "azurerm_resource_group" "rg" {
  name     = "${var.resourceGroupBaseName}-${var.environmentName}"
  location = var.location
}

resource "azurerm_storage_account" "sa" {
  name                     = "${var.storageAccountPrefix}${var.environmentName}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_kind             = "StorageV2"
  account_replication_type = "LRS"
}

resource "azurerm_app_service_plan" "sp" {
  name                = "${var.functionAppBaseName}-Plan"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  kind                = "FunctionApp"
  sku {
    tier = "Dynamic"
    size = "Y1"
  }
}

resource "azurerm_function_app" "fa" {
  name                      = "${var.functionAppBaseName}-${var.environmentName}"
  location                  = azurerm_resource_group.rg.location
  resource_group_name       = azurerm_resource_group.rg.name
  app_service_plan_id       = azurerm_app_service_plan.sp.id
  storage_connection_string = azurerm_storage_account.sa.primary_connection_string
}