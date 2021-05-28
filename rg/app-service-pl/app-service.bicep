//names
param disambiguationPhrase string = ''
param serverFarmName string = 'farm-${disambiguationPhrase}${uniqueString(subscription().id, resourceGroup().id)}'
param webSiteName string = 'web-${disambiguationPhrase}${uniqueString(subscription().id, resourceGroup().id)}'

param location string = resourceGroup().location

//required
param tags object

resource serverFarm 'Microsoft.Web/serverfarms@2020-12-01' = {
  name: serverFarmName
  location: location
}

resource webSite 'Microsoft.Web/sites@2020-12-01' = {
  name: webSiteName
  location: location
  properties: {
    serverFarmId: serverFarm.id
  }
}
