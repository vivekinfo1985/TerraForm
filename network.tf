resource "azurerm_virtual_network" "IaaC-vnet1" {
name = "${var.prefix}-vnet1"
location = var.location
resource_group_name = azurerm_resource_group.IaaC.name
address_space = ["10.0.0.0/16"]
}
resource "azurerm_subnet" "IaaC-pri-subnet1" {
name = "${var.prefix}-pri-subnet1"
resource_group_name = azurerm_resource_group.IaaC.name
virtual_network_name = azurerm_virtual_network.IaaC-vnet1.name
address_prefixes = ["10.0.1.0/24"]
}
resource "azurerm_subnet" "IaaC-pri-subnet2" {
name = "${var.prefix}-pri-subnet2"
resource_group_name = azurerm_resource_group.IaaC.name
virtual_network_name = azurerm_virtual_network.IaaC-vnet1.name
address_prefixes = ["10.0.2.0/24"]
}
resource "azurerm_network_security_group" "allow-ssh" {
name = "${var.prefix}-allow-ssh"
location = var.location
resource_group_name = azurerm_resource_group.IaaC.name

	security_rule {
		name = "SSH"
		priority = 1001
		direction = "Inbound"
		access = "Allow"
		protocol = "Tcp"
		source_port_range = "*"
		destination_port_range = "22"
		source_address_prefix = var.ssh-source-address
		destination_address_prefix = "*"
	}
}

resource "azurerm_network_security_group" "allow-http" {
name = "${var.prefix}-allow-http"
location = var.location
resource_group_name = azurerm_resource_group.IaaC.name

security_rule {
    name                       = "allow-http"
    description                = "allow-http"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }
}

# Associate the web NSG with the Subnet
resource "azurerm_subnet_network_security_group_association" "IaaC-pri-subnet1-linuxweb" {
  depends_on = [azurerm_network_security_group.allow-http]
  subnet_id  = azurerm_subnet.IaaC-pri-subnet1.id
  network_security_group_id = azurerm_network_security_group.allow-http.id #, azurerm_network_security_group.allow-http.id]
#}
# Associate the web NSG with the Subnet
#resource "azurerm_subnet_network_security_group_association" "IaaC-pri-subnet1-linuxweb" {
#  depends_on=[azurerm_network_security_group.allow-http]
#  subnet_id                 = azurerm_subnet.IaaC-pri-subnet1.id
#  network_security_group_id = azurerm_network_security_group.allow-http.id
}


