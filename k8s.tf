resource "azurerm_log_analytics_workspace" "log_workspace" {
  # The WorkSpace name has to be unique across the whole of azure, not just the current subscription/tenant.
  name                = local.logname
  location            = var.region_name
  resource_group_name = azurerm_resource_group.resourcegroup.name
  sku                 = "PerGB2018"
}
resource "azurerm_log_analytics_solution" "log_solution" {
  solution_name         = "ContainerInsights"
  location              = var.region_name
  resource_group_name   = azurerm_resource_group.resourcegroup.name
  workspace_resource_id = azurerm_log_analytics_workspace.log_workspace.id
  workspace_name        = azurerm_log_analytics_workspace.log_workspace.name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/ContainerInsights"
  }
}
resource "azurerm_kubernetes_cluster" "k8s" {
  name                = local.cluster_name
  location            = var.region_name
  resource_group_name = azurerm_resource_group.resourcegroup.name
  dns_prefix          = local.cluster_dns_prefix

  linux_profile {
    admin_username = "ubuntu"

    ssh_key {
      key_data = "${file("./id_rsa.pub")}"
    }
  }

  default_node_pool {
    name            = "systempool"
    node_count      = 1
    vm_size         = "Standard_D2_v2"
    //vnet_subnet_id  = element(azurerm_subnet.snets,2).id
  }

  identity {
    type = "SystemAssigned"
  }

  addon_profile {
    oms_agent {
      enabled                    = true
      log_analytics_workspace_id = azurerm_log_analytics_workspace.log_workspace.id
    }
  }


  network_profile {
    load_balancer_sku = "Standard"
    network_plugin = "azure"
  }

  tags = {
    Environment = "Development"
    ProjectName = var.project_name
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "user" {
  name                  = "user"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.k8s.id
  vm_size               = "Standard_DS2_v2"
  node_count            = 1
  //vnet_subnet_id        = element(azurerm_subnet.snets,1).id
}