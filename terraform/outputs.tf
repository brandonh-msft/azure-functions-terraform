output "subscription_id" {
  value = data.azurerm_client_config.current.subscription_id
}

output "delivery_topic_endpoint" {
  value = module.shared.delivery_topic_endpoint
}