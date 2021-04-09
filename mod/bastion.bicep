//names
param disambiguationPhrase string = ''
param bastionName string = 'bastion-${disambiguationPhrase}${uniqueString(subscription().id, resourceGroup().id)}'
param pipName string = 'pip-${disambiguationPhrase}${uniqueString(subscription().id, resourceGroup().id)}'
param location string = resourceGroup().location

//required
param subnetId string
param tags object

resource pip 'Microsoft.Network/publicIPAddresses@2020-06-01' = {
  name: pipName
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
  tags: tags
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
  tags: tags
}
