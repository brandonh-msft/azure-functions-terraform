resource "azurerm_app_service_plan" "sp" {
  name                = format("%s-%s-fx-plan-%s", var.appname, var.domainprefix, var.environment)
  location            = var.location
  resource_group_name = var.resource_group_name
  kind                = "functionapp"
  reserved            = true
  sku {
    tier = "Dynamic"
    size = "Y1"
  }
}

resource "azurerm_storage_account" "sa" {
  name                     = "${var.domainprefix}${var.environment}stor"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_kind             = "StorageV2"
  account_replication_type = "LRS"
}

resource "azurerm_function_app" "fa" {
  name                      = "${var.appname}-${var.domainprefix}-${var.environment}"
  location                  = var.location
  resource_group_name       = var.resource_group_name
  app_service_plan_id       = azurerm_app_service_plan.sp.id
  storage_connection_string = azurerm_storage_account.sa.primary_connection_string
  # Our Function App is a func v3 app
  version = "~3"
  app_settings = {
    APPINSIGHTS_INSTRUMENTATIONKEY = var.appInsightsKey
  }
}
