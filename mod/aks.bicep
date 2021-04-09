//names
param disambiguationPhrase string = ''
param aksName string = 'aks-${disambiguationPhrase}${uniqueString(subscription().id, resourceGroup().id)}'

param location string = resourceGroup().location

//required
param tags object
param vnetSubnetId string

resource aks 'Microsoft.ContainerService/managedClusters@2021-02-01' = {
  name: aksName
  location: location
  properties: {
    agentPoolProfiles: [
      {
        name: 'pool1'
        count: 1
        vnetSubnetID: vnetSubnetId
      }
    ]
  }
}
