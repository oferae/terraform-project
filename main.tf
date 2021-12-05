resource "azurerm_resource_group" "aks-resgrp" {
  name     = var.resource_group_name
  location = var.location
}
#creating resource group in azure

#create the role assign to download docker images from acr.
resource "azurerm_role_assignment" "role_acrpull" {
  scope                            = azurerm_container_registry.acr.id
  role_definition_name             = "AcrPull"
  principal_id                     = azurerm_kubernetes_cluster.aks.kubelet_identity.0.object_id
  skip_service_principal_aad_check = true
}
#creating the container registry, picking from tfvars file
resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = azurerm_resource_group.aks-resgrp.name
  location            = var.location
  sku                 = "Standard"
  admin_enabled       = false
}

#creating the aks cluster
resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.cluster_name
  kubernetes_version  = var.kubernetes_version
  location            = var.location
  resource_group_name = azurerm_resource_group.aks-resgrp.name
  dns_prefix          = var.cluster_name

  default_node_pool {
    name                = "system"
    node_count          = var.system_node_count
    vm_size             = "Standard_DS2_v2"
    type                = "VirtualMachineScaleSets"
    availability_zones  = [1, 2, 3]
    enable_auto_scaling = false
  }

  identity {
    type = "SystemAssigned"
  }
  #enable ingress aks cluster
  addon_profile {
    http_application_routing {
      enabled = true
    }
  }
#creating network profile for aks cluster
  network_profile {
    load_balancer_sku = "Standard"
    network_plugin    = "kubenet" 
  }
}

#we declare all of resources - resource grooup, aks, create cubernets kluster
#locations 
#and defining variables here this defs comes from terraform.tfvars
