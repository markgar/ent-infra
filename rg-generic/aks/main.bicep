targetScope = 'subscription'

param rgName string

var tags = {
  'env': 'dev'
}

param now string = utcNow()
var vnetId = '/subscriptions/75ebdae9-6e1c-4baa-8b2e-5576f6356a91/resourceGroups/m-shared-vnet/providers/Microsoft.Network/virtualNetworks/vnet-4p7rjz3pg5tyy'
var subnetName = 'aks'

param aksSPClientId string
param aksSPSecret string

resource rg 'Microsoft.Resources/resourceGroups@2020-06-01' = {
  name: rgName
  location: 'eastus'
}

module deployAks './aks.bicep' = {
  name: 'createAks-${now}'
  scope: rg
  params: {
    vnetSubnetId: '${vnetId}/subnets/${subnetName}'
    tags: tags
    aksSPClientId: aksSPClientId
    aksSPSecret: aksSPSecret
  }
}
