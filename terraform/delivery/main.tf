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
resource "random_integer" "stor" {
  min     = 1
  max     = 99999
}

resource "azurerm_storage_account" "inbox" {
# Note:  The terraform language server, v0.0.9, does not have support for the implicit
#        count.index, each.key or each.value variables which are created by terraform when it 
#        encounters the resource arguments 'count' or 'for_each'.
#        The fix is in: https://github.com/juliosueiras/terraform-lsp/pull/43 which is expected in v0.0.10
#        For now, ignore these errors/warnings.
  name                     = format("%sinboxsa%s%05.0f", var.appname, var.environment, random_integer.stor.result)
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
  name = "${azurerm_storage_account.inbox.name}-primary-key"
  value = azurerm_storage_account.inbox.primary_access_key
  key_vault_id = var.key_vault_id
}