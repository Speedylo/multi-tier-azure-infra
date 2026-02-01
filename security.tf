resource "azurerm_network_security_group" "public-nsg" {
  name                = "public-nsg"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  tags = { environment = "dev" }
}

resource "azurerm_network_security_rule" "public-nsr" {
  name                        = "public-nsr"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_ranges     = var.public_allowed_ports
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.public-nsg.name
}

resource "azurerm_network_security_rule" "allow-monitoring-node-exporter" {
  name                        = "allow-monitoring-node-exporter"
  priority                    = 200
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_ranges     = var.monitoring_port_public
  source_address_prefix       = "10.0.2.5"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.public-nsg.name
}

resource "azurerm_subnet_network_security_group_association" "public-sga" {
  subnet_id                 = azurerm_subnet.public-subnet.id
  network_security_group_id = azurerm_network_security_group.public-nsg.id
}

resource "azurerm_network_security_group" "private-nsg" {
  name                = "private-nsg"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  tags = { environment = "dev" }
}

resource "azurerm_network_security_rule" "private-nsr" {
  name                         = "private-nsr"
  priority                     = 100
  direction                    = "Inbound"
  access                       = "Allow"
  protocol                     = "Tcp"
  source_port_range            = "*"
  destination_port_ranges      = var.private_allowed_ports
  source_address_prefixes      = azurerm_subnet.public-subnet.address_prefixes
  destination_address_prefixes = azurerm_subnet.private-subnet.address_prefixes
  resource_group_name          = azurerm_resource_group.rg.name
  network_security_group_name  = azurerm_network_security_group.private-nsg.name
}

resource "azurerm_subnet_network_security_group_association" "private-sga" {
  subnet_id                 = azurerm_subnet.private-subnet.id
  network_security_group_id = azurerm_network_security_group.private-nsg.id
}