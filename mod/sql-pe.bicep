//names
param disambiguationPhrase string = ''
param pipName string = 'pip-${disambiguationPhrase}${uniqueString(subscription().id, resourceGroup().id)}'
param dnsZoneGroupName string = 'zonegroup-${disambiguationPhrase}${uniqueString(subscription().id, resourceGroup().id)}'
param privateEndpointName string = 'pe-${disambiguationPhrase}${uniqueString(subscription().id, resourceGroup().id)}'
param location string = resourceGroup().location

//required
param dnsZoneName string
param sqlServerId string
param vnetId string
param vnetSubnetId string
param tags object

resource sqlPrivateEndpoint 'Microsoft.Network/privateEndpoints@2020-06-01' = {
  name: privateEndpointName
  location: location
  properties: {
    subnet: {
      id: vnetSubnetId
    }
    privateLinkServiceConnections: [
      {
        name: privateEndpointName
        properties: {
          privateLinkServiceId: sqlServerId
          groupIds: [
            'sqlServer'
          ]
        }
      }
    ]
  }
  tags: tags
}

resource zoneGroup 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2020-06-01' = {
  name: '${privateEndpointName}/default'
  properties: {
    privateDnsZoneConfigs: [
      {
        name: 'config1'
        properties: {
          privateDnsZoneId: '${dnsZone.id}'
        }
      }
    ]
  }
  //tags: tags
}

resource dnsZone 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: dnsZoneName
  location: 'global'
  tags: tags
}



resource link 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  name: '${dnsZoneName}/${dnsZoneName}-link'
  location: 'global'
  properties: {
    registrationEnabled: true
    virtualNetwork: {
      id: vnetId
    }
  }
  tags: tags
  // dependsOn: [
  //   dnsZone
  // ]
}
