provider "azurerm" {
  # Whilst version is optional, we /strongly recommend/ using it to pin the version of the Provider being used
  # version = "=2.4.0"

  subscription_id = "c33b1256-a4ef-4e27-bec6-50e7e6d560ff"
  client_id       = "f256ed1e-8ff9-4534-b703-fda0fdf9b288"
  client_secret   = "9Tya70hba8Mgdfk_FJ9Uo6Y3I3._MgAPV-"
  tenant_id       = "bb405fc4-ee82-43b4-a2be-f2c13800c755"

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
