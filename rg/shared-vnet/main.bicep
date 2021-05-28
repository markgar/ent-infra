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

module createVnet './vnet.bicep' = {
  name: 'createVnet-${now}'
  scope: rg
  params: {
    tags: tags
  }
}

module createPrivateZones 'private-zones.bicep' = {
  scope: rg
  name: 'createPrivateZones-${now}'
  params: {
    tags: tags
    vnetName: 'vnet-4p7rjz3pg5tyy'
    vnetResourceGroupName: 'm-shared-vnet'
  }
  
}

module createBastion './../../mod/bastion.bicep' = {
  scope: rg
  name: 'createBastion-${now}'
  params: {
    subnetId: createVnet.outputs.bastionSubnetId
    tags: tags
  }
}
