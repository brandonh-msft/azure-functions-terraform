##################################################################################
# Delivery Terraform file
##################################################################################

##################################################################################
# RESOURCES
##################################################################################

# Using count argument, we can create multiple numbered resources.
# Ref: https://www.terraform.io/docs/configuration/resources.html#count-multiple-resource-instances-by-count
#
# We use format("prefix-inbox%02.0f-suffix", count.index) to ensure sortable names like "inbox01"
# Ref: https://www.terraform.io/docs/configuration/functions/format.html
#
resource "azurerm_storage_account" "inbox" {
  count = var.number_of_inboxes
# Note:  The terraform language server, v0.0.9, does not have support for the implicit
#        count.index, each.key or each.value variables which are created by terraform when it 
#        encounters the resource arguments 'count' or 'for_each'.
#        The fix is in: https://github.com/juliosueiras/terraform-lsp/pull/43 which is expected in v0.0.10
#        For now, ignore these errors/warnings.
  name                     = format("%sinbox%02.0fsa%s", var.appname, count.index, var.environment)
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind = "StorageV2"
}

#############################
# Secrets
#############################

resource "azurerm_key_vault_secret" "inboxes_secrets" {
  count = var.number_of_inboxes

  name = "${azurerm_storage_account.inbox[count.index].name}-primary-key"
  value = azurerm_storage_account.inbox[count.index].primary_access_key
  key_vault_id = var.key_vault_id
}