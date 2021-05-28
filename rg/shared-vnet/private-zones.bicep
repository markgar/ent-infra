//names
param disambiguationPhrase string = ''

param location string = resourceGroup().location

//required
param vnetName string
param vnetResourceGroupName string
param tags object

resource vnetRef 'Microsoft.Network/virtualNetworks@2020-11-01' existing = {
  name: vnetName
  scope: resourceGroup(vnetResourceGroupName) 
}

resource dnsZone 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: 'privatelink.database.windows.net'
  location: 'global'
  tags: tags
}

resource link 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  name: 'privatelink.database.windows.net/privatelink.database.windows.net-link'
  location: 'global'
  properties: {
    registrationEnabled: true
    virtualNetwork: {
      id: vnetRef.id
    }
  }
  tags: tags
}
