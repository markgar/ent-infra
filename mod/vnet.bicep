//names
param disambiguationPhrase string = ''
param virtualNetworkName string = 'vnet-${disambiguationPhrase}${uniqueString(subscription().id, resourceGroup().id)}'
param networkSecurityGroupName string = 'nsg-${disambiguationPhrase}${uniqueString(subscription().id, resourceGroup().id)}'

param location string = resourceGroup().location

//required
param tags object

resource sg 'Microsoft.Network/networkSecurityGroups@2020-06-01' = {
  name: networkSecurityGroupName
  location: location
  properties: {
    securityRules: [
      // {
      //   name: 'default-allow-3389'
      //   'properties': {
      //     priority: 1000
      //     access: 'Allow'
      //     direction: 'Inbound'
      //     destinationPortRange: '3389'
      //     protocol: 'Tcp'
      //     sourcePortRange: '*'
      //     sourceAddressPrefix: '*'
      //     destinationAddressPrefix: '*'
      //   }
      // }
    ]
  }
  tags: tags
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
      {
        name: 'privatelink'
        properties: {
          addressPrefix: '10.0.2.0/24'
          privateEndpointNetworkPolicies: 'Disabled'
        }
      }
      {
        name: 'aks'
        properties: {
          addressPrefix: '10.0.3.0/24'
        }
      }
    ]
  }
  tags: tags
}

output vnetId string = vn.id 
output defaultSubnetId string = resourceId('Microsoft.Network/virtualNetworks/subnets/', '${virtualNetworkName}' ,'default')
output bastionSubnetId string = resourceId('Microsoft.Network/virtualNetworks/subnets/', '${virtualNetworkName}' ,'AzureBastionSubnet')
output privateLinkSubnetId string = resourceId('Microsoft.Network/virtualNetworks/subnets/', '${virtualNetworkName}' ,'privatelink')
