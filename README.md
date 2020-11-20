# iac_azure_aks
Template for setting up an K8s in Azure.

[Template implementation](https://docs.microsoft.com/de-de/azure/aks/configure-kubenet)  
[Hint why Subnets cannot be assigned to pools](https://github.com/Azure/AKS/issues/1653)

## Network
Using following network settings: 
* VNET CIDR 10.10.0.0/16
* Subnets bastion/24 agw/24 system/20 user/20
* Service CIDR 192.168.0.0/16
* Docker 172.16.0.1/16