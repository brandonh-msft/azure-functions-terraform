##################################################################################
# RESOURCES
##################################################################################

resource "azurerm_application_insights" "logging" {
  name                = format("%s-ai-%s", var.appname, var.environment)
  location            = var.location
  resource_group_name = var.resource_group_name
  application_type    = "web"
}

#############################
# Secrets
#############################

resource "azurerm_key_vault_secret" "logging_app_insights_key" {
  name = "application-insights-instrumentation-key"
  value = azurerm_application_insights.logging.instrumentation_key
  key_vault_id = var.key_vault_id
}