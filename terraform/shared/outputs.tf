output "shared_key_vault_id" {
  value = azurerm_key_vault.shared_key_vault.id
}

output "shared_key_vault_name" {
  value = azurerm_key_vault.shared_key_vault.name
}

output "delivery_topic_endpoint" {
  value = azurerm_eventgrid_topic.delivery_topic.endpoint
}

output "delivery_topic_name" {
  value = azurerm_eventgrid_topic.delivery_topic.name
}

output "delivery_topic_key" {
  value = azurerm_eventgrid_topic.delivery_topic.primary_access_key
}
