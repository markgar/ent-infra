targetScope = 'subscription'

param adminUsername string

@secure()
param adminPassword string

param rgName string

var tags = {
  'env': 'sbx'
}
param now string = utcNow()
var vnetId = '/subscriptions/75ebdae9-6e1c-4baa-8b2e-5576f6356a91/resourceGroups/m-shared-vnet/providers/Microsoft.Network/virtualNetworks/vnet-4p7rjz3pg5tyy'
var subnetName = 'default'

resource rg 'Microsoft.Resources/resourceGroups@2020-06-01' = {
  name: rgName
  location: 'eastus'
}

// module createVnet './../../mod/vnet.bicep' = {
//   scope: rg
//   name: 'createVnet'
//   params: {
//     tags: tags
//   }
// }

module createArcHostVM './../../mod/dev-vm.bicep' = {
  scope: rg
  name: 'createVM'
  params: {
    adminPassword: adminPassword
    adminUsername: adminUsername
    vmSubnetId: '${vnetId}/subnets/${subnetName}'
    tags: tags
    vmSize: 'Standard_D8s_v4'
    
  }
}


