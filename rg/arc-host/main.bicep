targetScope = 'subscription'

var vnetNamingGuid = '3c65518d-f71b-4348-87ba-71c9f4313f8a'
var vmNamingGuid = 'a8a1e460-8864-11eb-8dcd-0242ac130003'
var bastionNamingGuid = 'b0288559-9775-407f-86d0-c6896e991ef4'

param adminUsername string

@secure()
param adminPassword string

param rgName string

resource rg 'Microsoft.Resources/resourceGroups@2020-06-01' = {
  name: rgName
  location: 'eastus'
}

module createVnet './../../mod/vnet.bicep' = {
  scope: rg
  name: 'createVnet'
  params:{
    namingGuid: vnetNamingGuid
  }
}

module createArcHostVM './../../mod/dev-vm.bicep' = {
  scope: rg
  name: 'createArcHostVM'
  params: {
    adminPassword: adminPassword
    adminUsername: adminUsername
    vmSubnetId: createVnet.outputs.defaultSubnetId
    namingGuid: vmNamingGuid
  }
}

// module createBastion './../../mod/bastion.bicep' = {
//   scope: rg
//   name: 'createBastion'
//   params: {
//     subnetId: createVnet.outputs.bastionSubnetId
//     namingGuid: bastionNamingGuid
//   }
// }