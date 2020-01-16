##################################################################################
# Main Terraform file 
##################################################################################

locals {
  dev_environment_name = "dev"
}

##################################################################################
# RESOURCES
##################################################################################

resource "azurerm_resource_group" "delivery" {
  name     = "${var.appname}-delivery-rg-${var.environment}"
  location = var.location
  tags = {
    department      = var.department
    appname         = var.appname
    functional_area = "delivery"
  }
}

resource "azurerm_resource_group" "shared" {
  name     = "${var.appname}-shared-rg-${var.environment}"
  location = var.location
  tags = {
    department      = var.department
    appname         = var.appname
    functional_area = "delivery"
  }
}

module "delivery" {
  source              = "./delivery"
  appname             = var.appname
  number_of_inboxes   = 3
  environment         = var.environment
  resource_group_name = azurerm_resource_group.delivery.name
  location            = azurerm_resource_group.delivery.location
  key_vault_id        = module.shared.shared_key_vault_id
}

module "appinsights" {
  source              = "./appinsights"
  appname             = var.appname
  environment         = var.environment
  resource_group_name = azurerm_resource_group.delivery.name
  location            = azurerm_resource_group.delivery.location
  key_vault_id        = module.shared.shared_key_vault_id
}

module "function" {
  source               = "./function"
  appname              = var.appname
  domainprefix         = var.domainprefix
  environment          = var.environment
  resource_group_name  = azurerm_resource_group.delivery.name
  location             = azurerm_resource_group.delivery.location
  appInsightsKey       = module.appinsights.instrumentation_key
  deliveryTopicBaseUri = module.shared.delivery_topic_endpoint
  deliveryTopicName    = module.shared.delivery_topic_name
  deliveryTopicKey     = module.shared.delivery_topic_key
}

module "shared" {
  source                   = "./shared"
  key_vault_tenant_id      = data.azurerm_client_config.current.tenant_id
  appname                  = var.appname
  access_policy_object_ids = var.environment == local.dev_environment_name ? [data.azurerm_client_config.current.object_id] : [data.azurerm_client_config.current.service_principal_object_id]
  environment              = var.environment
  resource_group_name      = azurerm_resource_group.shared.name
  location                 = azurerm_resource_group.shared.location
}

# Add additional functional areas...
