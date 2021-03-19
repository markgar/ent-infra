//names
param namingGuid string
param bastionName string = 'bastion-${substring(uniqueString(resourceGroup().id, namingGuid), 1, 8)}'
param pipName string = 'pip-${substring(uniqueString(resourceGroup().id, namingGuid), 1, 8)}'
param location string = resourceGroup().location

//required
param subnetId string


resource pip 'Microsoft.Network/publicIPAddresses@2020-06-01' = {
  name: pipName
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}

resource bastion 'Microsoft.Network/bastionHosts@2020-06-01' = {
  name: bastionName
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'IpConf'
        properties: {
          subnet: {
            id: subnetId
          }
          publicIPAddress: {
            id: pip.id
          }
        }
      }
    ]
  }
}