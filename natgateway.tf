resource "azurerm_nat_gateway" "ngw" {
  depends_on = [azurerm_kubernetes_cluster.k8s, azurerm_kubernetes_cluster_node_pool.user]
  name                    = local.nat-name
  location                = var.region_name
  resource_group_name     = azurerm_resource_group.resourcegroup.name
  public_ip_prefix_ids    = [ azurerm_public_ip_prefix.ngw.id ]
  sku_name                = "Standard"
  idle_timeout_in_minutes = 10
}

resource "azurerm_subnet_nat_gateway_association" "snetlink" {
  count = length(local.snets)
  subnet_id      = element(azurerm_subnet.snets, count.index).id
  nat_gateway_id = azurerm_nat_gateway.ngw.id
}