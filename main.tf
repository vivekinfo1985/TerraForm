provider "azurerm" {
  # Whilst version is optional, we /strongly recommend/ using it to pin the version of the Provider being used
  # version = "=2.4.0"

  subscription_id = ""
  client_id       = ""
  client_secret   = ""
  tenant_id       = ""

  features {}
}

#Creating a resource group

resource "azurerm_resource_group" "IaaC" {
  name     = "CloudLearning"
  location = var.location

  tags = {
		Description = "Cloud Practical"
	 }
}
