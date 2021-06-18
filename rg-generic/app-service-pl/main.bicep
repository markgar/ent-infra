targetScope = 'subscription'

param rgName string

var tags = {
  'env': 'dev'
}

param now string = utcNow()

resource rg 'Microsoft.Resources/resourceGroups@2020-06-01' = {
  name: rgName
  location: 'eastus'
}

module createAppServiceSite 'app-service.bicep' = {
  scope: rg
  name: 'createAppServiceSite-${now}'
  params: {
    tags: tags
    vnetResourceGroupName: 'm-shared-vnet'
    vnetName: 'vnet-4p7rjz3pg5tyy'
    vnetSubnetName: 'privatelink'
  }
}
//test //
