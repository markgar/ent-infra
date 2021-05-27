targetScope = 'subscription'

param adminUsername string

@secure()
param adminPassword string

param rgName string

var tags = {
  'env': 'sbx'
}
param now string = utcNow()
var vnetName = 'vnet-4p7rjz3pg5tyy'
var vnetResourceGroupName = 'm-shared-vnet'
var subnetName = 'default'

resource rg 'Microsoft.Resources/resourceGroups@2020-06-01' = {
  name: rgName
  location: 'eastus'
}

resource vnet 'Microsoft.Network/virtualNetworks@2020-11-01' existing = {
  name: vnetName
  scope: resourceGroup(vnetResourceGroupName)
}

module createArcHostVM './../../mod/dev-vm.bicep' = {
  scope: rg
  name: 'createVM'
  params: {
    adminPassword: adminPassword
    adminUsername: adminUsername
    vmSubnetId: '${vnet.id}/subnets/${subnetName}'
    tags: tags
    vmSize: 'Standard_D8s_v4'
    
  }
}


