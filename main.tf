provider "azurerm" {
  # The "feature" block is required for AzureRM provider 2.x.
  # If you are using version 1.x, the "features" block is not allowed.
  version = "~>2.36.0"
  features {}
}

locals {
  vnet-name = "vnet-${var.region_name}-${var.project_name}"
  vnet-cidr = "10.0.0.0/16"
  snets = ["agw", "user", "system"]
  snet-cidrs = cidrsubnets(local.vnet-cidr,8,8,4,4)
  rg-name = "rg-${var.region_name}-${var.project_name}"
  snet-name = "snet-${var.region_name}-${var.project_name}"

  nsg-name = "nsg-${var.region_name}-${var.project_name}"
  nat-name = "nat-${var.region_name}-${var.project_name}"
  nat-name-pre = "nat-${var.region_name}-${var.project_name}-publicipprefix"

  //snetbast-name = "AzureBastionSubnet"
  //pip-name = "pip-${var.region_name}-${var.project_name}"
  //bast-name = "bast-${var.region_name}-${var.project_name}"
}