resource "azurerm_public_ip" "IaaC-lb-pip" {
  name                = "${var.prefix}-lb-pip"
  location            = var.location
  resource_group_name = azurerm_resource_group.IaaC.name
  allocation_method   = "Static"
}

resource "azurerm_lb" "IaaC-lb" {
  name                = "${var.prefix}-lb"
  location            = var.location
  resource_group_name = azurerm_resource_group.IaaC.name

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.IaaC-lb-pip.id
  }
}

resource "azurerm_lb_backend_address_pool" "IaaC-lb-backend" {
  resource_group_name = azurerm_resource_group.IaaC.name
  loadbalancer_id     = azurerm_lb.IaaC-lb.id
  name                = "BackEndAddressPool"
  #load_balancer_backend_address_pool_ids = azurerm_lb_backend_address_pool.IaaC-lb-backend.id
}

resource "azurerm_network_interface" "IaaC-network-interface" {
  name                = "${var.prefix}-network-interfae"
  location            = var.location
  resource_group_name = azurerm_resource_group.IaaC.name

  ip_configuration {
    name                          = "IaaC-ip-configuration"
    subnet_id                     = azurerm_subnet.IaaC-pri-subnet1.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface_backend_address_pool_association" "IaaC-backend-association" {
  network_interface_id    = azurerm_network_interface.IaaC-network-interface.id
  ip_configuration_name   = "IaaC-ip-configuration"
  backend_address_pool_id = azurerm_lb_backend_address_pool.IaaC-lb-backend.id
}

resource "azurerm_lb_rule" "IaaC-lb-rule" {
  resource_group_name            = azurerm_resource_group.IaaC.name
  loadbalancer_id                = azurerm_lb.IaaC-lb.id
  name                           = "IaaC-lb-Rule"
  protocol                       = "Tcp"
  frontend_port                  = 22
  backend_port                   = 22
  frontend_ip_configuration_name = "PublicIPAddress"
}

resource "azurerm_lb_probe" "IaaC-lb-probe" {
  resource_group_name = azurerm_resource_group.IaaC.name
  loadbalancer_id     = azurerm_lb.IaaC-lb.id
  name                = "ssh-running-probe"
  port                = 22
}
