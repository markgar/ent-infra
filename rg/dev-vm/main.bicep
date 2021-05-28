targetScope = 'subscription'

param adminUsername string

@secure()
param adminPassword string

param rgName string

var tags = {
  'env': 'sbx'
}
param now string = utcNow()
var subnetName = 'default'

resource rg 'Microsoft.Resources/resourceGroups@2020-06-01' = {
  name: rgName
  location: 'eastus'
}

// module createVnet './../../mod/vnet.bicep' = {
//   scope: rg
//   name: 'createVnet-${now}'
//   params: {
//     tags: tags
//   }
// }

// resource vnetRef 'Microsoft.Network/virtualNetworks@2020-11-01' existing = {
//   name: 'vnet-4p7rjz3pg5tyy'
//   scope: resourceGroup('m-shared-vnet')
// }

resource subnetRef 'Microsoft.Network/virtualNetworks/subnets@2020-11-01' existing = {
  name: 'vnet-4p7rjz3pg5tyy/${subnetName}'
  scope: resourceGroup('m-shared-vnet')
}

module createArcHostVM './../../mod/dev-vm.bicep' = {
  scope: rg
  name: 'createVM-${now}'
  params: {
    adminPassword: adminPassword
    adminUsername: adminUsername
    vmSubnetId: subnetRef.id
    tags: tags
    vmSize: 'Standard_D8s_v4'
  }
}

// module createBastion './../../mod/bastion.bicep' = {
//   scope: rg
//   name: 'createBastion-${now}'
//   params: {
//     subnetId: createVnet.outputs.bastionSubnetId
//     namingGuid: bastionNamingGuid
//   }
// }
