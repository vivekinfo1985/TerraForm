# Get a Dynamic Public IP
resource "azurerm_public_ip" "IaaC-linuxvm-pip" {
  name = "${var.prefix}-linuxvm-pip"
  location            = var.location
  resource_group_name = azurerm_resource_group.IaaC.name
  allocation_method   = "Dynamic"
  
}

resource "azurerm_network_interface" "IaaC-linuxvmNic" {
name = "${var.prefix}-linuxvmNic"
location = var.location
resource_group_name = azurerm_resource_group.IaaC.name

        ip_configuration {
                name = "linuxvmNic"
                subnet_id = azurerm_subnet.IaaC-pri-subnet1.id
                private_ip_address_allocation = "Dynamic"
                public_ip_address_id = azurerm_public_ip.IaaC-linuxvm-pip.id
        }
}

resource "azurerm_virtual_machine" "IaaC-linuxvm" {
name = "${var.prefix}-linuxvm"
location = var.location
resource_group_name = azurerm_resource_group.IaaC.name
network_interface_ids = [azurerm_network_interface.IaaC-linuxvmNic.id]
vm_size = "Standard_DS1_v2"

delete_os_disk_on_termination = true
delete_data_disks_on_termination = true

storage_image_reference {

	offer     = "UbuntuServer"
    	publisher = "Canonical"
	sku       = "18.04-LTS"
        version   = "latest"
}

storage_os_disk {
	name = "IaaC-linuxvm-disk"
	caching = "ReadWrite"
	create_option = "FromImage"
	managed_disk_type = "Standard_LRS"
}

os_profile {
	computer_name = "IaaC-linuxvm"
	admin_username = "vivek"
	admin_password = "P@ssw0rd1234"
	custom_data = file("InstallApache.sh")
}

os_profile_linux_config {
    disable_password_authentication = false
  }

}

