//names
param namingGuid string
param pipName string = 'pip-${substring(uniqueString(resourceGroup().id, namingGuid), 1, 8)}'
param dnsZoneName string = 'zone-${substring(uniqueString(resourceGroup().id, namingGuid), 1, 8)}'
param dnsZoneGroupName string = 'zonegroup-${substring(uniqueString(resourceGroup().id, namingGuid), 1, 8)}'
param privateEndpointName string = 'pe-${substring(uniqueString(resourceGroup().id, namingGuid), 1, 8)}'
param location string = resourceGroup().location

//required
param sqlServerId string
param vnetId string
param vnetSubnetId string

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
}

resource dnsZone 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: dnsZoneName
  location: 'global'
  // dependsOn: [
  //   vnet
  // ]
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
}

resource zoneGroup 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2020-06-01' = {
  name: '${privateEndpointName}/default'
  properties: {
    privateDnsZoneConfigs: [
      {
        name: 'config1'
        properties: {
          privateDnsZoneId: '${dnsZone.id}/privatelink.database.windows.net'
        }
      }
    ]
  }
}