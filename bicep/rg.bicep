@description('Name of the resource group')
param rgName string

@description('Location of the resource group')
param location string

module resourceGroupModule 'br:biceplearning.azurecr.io/modules/rg.bicep:2024-10-31' = {
  name: 'resourceGroupDeployment'
  scope: subscription()
  params: {
    rgName: rgName
    location: location
  }
}
