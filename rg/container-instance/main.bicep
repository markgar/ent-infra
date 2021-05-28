targetScope = 'subscription'

param rgName string

var tags = {
  'env': 'dev'
}

param now string = utcNow()

resource rg 'Microsoft.Resources/resourceGroups@2020-06-01' = {
  name: 'm-${rgName}'
  location: 'eastus'
}


module createContainerInstance 'aci.bicep' = {
  scope: rg
  name: 'createAci-${now}'
  params: {
    tags: tags
    vnetResourceGroupName: 'm-shared-vnet'
    vnetName: 'vnet-4p7rjz3pg5tyy'
    subnetName: 'aci'
  }
}
