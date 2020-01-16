##################################################################################
# Shared resources Terraform file
##################################################################################

##################################################################################
# RESOURCES
##################################################################################

resource "azurerm_key_vault" "shared_key_vault" {
  name                = "${var.appname}-kv-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tenant_id           = var.key_vault_tenant_id

  sku_name = "standard"

  dynamic "access_policy" {
    for_each = var.access_policy_object_ids
    content {
      tenant_id = var.key_vault_tenant_id
      object_id = access_policy.value

      key_permissions = [
        "get",
        "list",
        "create",
        "delete"
      ]

      secret_permissions = [
        "get",
        "list",
        "set",
        "delete"
      ]
    }
  }
}

#############################
# Main Topic
#############################

resource "azurerm_eventgrid_topic" "delivery_topic" {
  name                = "${var.appname}-aztf-egt-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
}

#############################
# Secrets
#############################

resource "azurerm_key_vault_secret" "delivery_topic_key_secret" {
  name         = "delivery-topic-key"
  value        = azurerm_eventgrid_topic.delivery_topic.primary_access_key
  key_vault_id = azurerm_key_vault.shared_key_vault.id
}

resource "azurerm_key_vault_secret" "delivery_topic_ep_secret" {
  name         = "delivery-topic-endpoint"
  value        = azurerm_eventgrid_topic.delivery_topic.endpoint
  key_vault_id = azurerm_key_vault.shared_key_vault.id
}
