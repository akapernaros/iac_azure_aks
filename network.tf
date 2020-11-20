/**
 * Create VNET and resource group for k8s and
 * subnets for system-, userpool and the default application-gateway and bastion.
 */

resource "azurerm_network_security_group" "security_group" {
  name = local.nsg-name
  location = var.region_name
  resource_group_name = azurerm_resource_group.resourcegroup.name
}

resource "azurerm_virtual_network" "virtual-network" {
  address_space = [local.vnet-cidr]
  location = var.region_name
  name = local.vnet-name
  resource_group_name = azurerm_resource_group.resourcegroup.name
}

resource "azurerm_subnet" "snets" {
  count = length(local.snets)
  address_prefixes = slice(local.snet-cidrs,count.index+1, count.index+2)
  name = "${local.snet-name}-${element(local.snets, count.index)}"
  resource_group_name = azurerm_resource_group.resourcegroup.name
  virtual_network_name = azurerm_virtual_network.virtual-network.name
}

resource "azurerm_subnet_network_security_group_association" "snet1_nsg_link" {
  count = length(local.snets)
  subnet_id                 = element(azurerm_subnet.snets, count.index).id
  network_security_group_id = azurerm_network_security_group.security_group.id
}

resource "azurerm_public_ip_prefix" "ngw" {
  name                = local.nat-name-pre
  location            = var.region_name
  resource_group_name = azurerm_resource_group.resourcegroup.name
  sku ="Standard"
  prefix_length = 31
}
