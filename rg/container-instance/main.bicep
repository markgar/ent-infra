targetScope = 'subscription'

param rgName string
param env string

var vnetId = '/subscriptions/75ebdae9-6e1c-4baa-8b2e-5576f6356a91/resourceGroups/m-shared-vnet/providers/Microsoft.Network/virtualNetworks/vnet-4p7rjz3pg5tyy'

var tags = {
  'env': 'dev'
}

param now string = utcNow()

resource rg 'Microsoft.Resources/resourceGroups@2020-06-01' = {
  name: 'm-${rgName}-${env}'
  location: 'eastus'
}


module createStorage 'aci.bicep' = {
  scope: rg
  name: 'createAci-${now}'
  params: {
    tags: tags
    subnetId: '${vnetId}/subnets/aci'
  }
}
