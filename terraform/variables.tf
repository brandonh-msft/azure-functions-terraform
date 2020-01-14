variable "environmentName" {
  description="The environment to which this infrastructure is being deployed"
}

variable "subscriptionId" {
  description = "The Azure Subscription ID to which to apply the Terraform infrastructure"
}

variable "tenantId" {
  description="The Azure Tenant ID to which to apply the Terraform infrastructure. 'subscriptionId' must exist within this tenant."
}

variable "resourceGroupBaseName" {
  description="The base name for the created Azure Resource group. This will be appended with the target environment name."
}

variable "storageAccountPrefix" {
  description="The base name for the storage account to use for the Function plan"
}

variable "location" {
  description="The Azure region in which to put all resources. This must map to an Azure Region id (e.g. 'westus', 'westus2', 'westeurope', etc)"
}

variable "functionAppBaseName" {
  description="The base name for the created function apps. These will be appended with the target environment name (e.g. 'myfunctionapp' -> 'myfunctionapp-QA')"
}