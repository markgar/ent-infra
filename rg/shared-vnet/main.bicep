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

module createBastion './../../mod/bastion.bicep' = {
  scope: rg
  name: 'createBastion-${now}'
  params: {
    subnetId: createVnet.outputs.bastionSubnetId
    tags: tags
  }
}
