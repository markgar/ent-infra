//names
param disambiguationPhrase string = ''
param serverName string = 'sqls-${disambiguationPhrase}${uniqueString(subscription().id, resourceGroup().id)}'
param location string = resourceGroup().location

//required
param sqlDBName string
param adminUsername string
@secure()
param adminPassword string
param tags object


resource sqlServer 'Microsoft.Sql/servers@2019-06-01-preview' = {
  name: serverName
  location: location
  properties: {
    administratorLogin: adminUsername
    administratorLoginPassword: adminPassword
  }
  tags: tags
}

resource sqlDB 'Microsoft.Sql/servers/databases@2020-08-01-preview' = {
  name: '${sqlServer.name}/${sqlDBName}'
  location: location
  sku: {
    name: 'Standard'
    tier: 'Standard'
  }
  tags: tags
}

output sqlServerId string = sqlServer.id
