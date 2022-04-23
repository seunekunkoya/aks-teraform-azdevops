#Set the terraform backend
terraform {
  required_version = ">= 0.12.6"

  backend "azurerm" {
    storage_account_name = "infrasdbx1vpcjdld1"
    container_name       = "tfstate"
    key                  = "BestPractice-4.tfstate"
    resource_group_name  = "infr-jdld-noprd-rg1"
  }
}

#Set the Provider
provider "azurerm" {
  version         = "~> 2.0" #Use the last version tested through an Azure DevOps pipeline here : https://dev.azure.com/jamesdld23/vpc_lab/_build
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
  features {}
}

#Call module/resource
data "azurerm_resource_group" "infr" {
  name = "infr-jdld-noprd-rg1"
}

#Action
module "Add-AzureRmLoadBalancerOutboundRules-Apps" {
  source                     = "git::https://github.com/JamesDLD/terraform.git//module/Add-AzureRmLoadBalancerOutboundRules?ref=master"
  lbs_out                    = var.lbs_public
  lb_out_prefix              = "bp4-"
  lb_out_suffix              = "-publiclb1"
  lb_out_resource_group_name = data.azurerm_resource_group.infr.name
  lbs_tags                   = data.azurerm_resource_group.infr.tags
}

