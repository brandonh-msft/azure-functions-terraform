output "shared_key_vault_id" {
  value = azurerm_key_vault.shared_key_vault.id
}

output "delivery_topic_endpoint" {
  value = azurerm_eventgrid_topic.delivery_topic.endpoint
}