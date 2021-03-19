//names
param namingGuid string
param virtualNetworkName string = 'vnet-${substring(uniqueString(resourceGroup().id, namingGuid), 1, 8)}'
param networkSecurityGroupName string = 'nsg-${substring(uniqueString(resourceGroup().id, namingGuid), 1, 8)}'

param location string = resourceGroup().location

resource sg 'Microsoft.Network/networkSecurityGroups@2020-06-01' = {
  name: networkSecurityGroupName
  location: location
  properties: {
    securityRules: [
      {
        name: 'default-allow-3389'
        'properties': {
          priority: 1000
          access: 'Allow'
          direction: 'Inbound'
          destinationPortRange: '3389'
          protocol: 'Tcp'
          sourcePortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
        }
      }
    ]
  }
}

resource vn 'Microsoft.Network/virtualNetworks@2020-06-01' = {
  name: virtualNetworkName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'default'
        properties: {
          addressPrefix: '10.0.0.0/24'
          networkSecurityGroup: {
            id: sg.id
          }
        }
      }
      {
        name: 'AzureBastionSubnet'
        properties: {
          addressPrefix: '10.0.1.0/24'
        }
      }
    ]
  }
}

output defaultSubnetId string = resourceId('Microsoft.Network/virtualNetworks/subnets/', '${virtualNetworkName}' ,'default')
output bastionSubnetId string = resourceId('Microsoft.Network/virtualNetworks/subnets/', '${virtualNetworkName}' ,'AzureBastionSubnet')