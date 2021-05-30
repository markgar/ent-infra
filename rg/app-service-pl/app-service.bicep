//names
param disambiguationPhrase string = ''
param serverFarmName string = 'farm-${disambiguationPhrase}${uniqueString(subscription().id, resourceGroup().id)}'
param webSiteName string = 'web-${disambiguationPhrase}${uniqueString(subscription().id, resourceGroup().id)}'
param privateEndpointName string = 'pe-${disambiguationPhrase}${uniqueString(subscription().id, resourceGroup().id)}'
param vnetResourceGroupName string
param vnetName string
param vnetSubnetName string

param location string = resourceGroup().location

//required
param tags object

resource serverFarm 'Microsoft.Web/serverfarms@2020-12-01' = {
  name: serverFarmName
  location: location
  sku: {
    name: 'P1v2'
  }
}

resource webSite 'Microsoft.Web/sites@2020-12-01' = {
  name: webSiteName
  location: location
  properties: {
    serverFarmId: serverFarm.id
  }
}

resource subnetRef 'Microsoft.Network/virtualNetworks/subnets@2020-11-01' existing = {
  name: '${vnetName}/${vnetSubnetName}'
  scope: resourceGroup(vnetResourceGroupName)
}

resource zoneRef 'Microsoft.Network/privateDnsZones@2020-06-01' existing = {
  name: 'privatelink.azurewebsites.net'
  scope: resourceGroup(vnetResourceGroupName)
}

resource webPrivateEndpoint 'Microsoft.Network/privateEndpoints@2020-06-01' = {
  name: privateEndpointName
  location: location
  properties: {
    subnet: {
      id: subnetRef.id
    }
    privateLinkServiceConnections: [
      {
        name: privateEndpointName
        properties: {
          privateLinkServiceId: webSite.id
          groupIds: [
            'sites'
          ]
        }
      }
    ]
  }
  tags: tags
}

resource zoneGroup 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2020-06-01' = {
  name: '${privateEndpointName}/default'
  dependsOn: [
    webPrivateEndpoint
  ]
  properties: {
    privateDnsZoneConfigs: [
      {
        name: 'privatelink-azurewebsites-net'
        properties: {
          privateDnsZoneId: zoneRef.id
        }
      }
    ]
  }
}

// a change
