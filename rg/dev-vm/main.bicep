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

resource vnetRef 'Microsoft.Network/virtualNetworks@2020-11-01' existing = {
  name: 'vnet-4p7rjz3pg5tyy'
  scope: resourceGroup('m-shared-vnet')
}

resource subnetRef 'Microsoft.Network/virtualNetworks/subnets@2020-11-01' existing = {
  parent: vnetRef
  name: subnetName
}

module createDevVM './private-vm.bicep' = {
  scope: rg
  name: 'createVM-${now}'
  params: {
    adminPassword: adminPassword
    adminUsername: adminUsername
    createPublicIP: false
    vmSubnetId: subnetRef.id
    tags: tags
    vmSize: 'Standard_D8s_v4'
  }
}
