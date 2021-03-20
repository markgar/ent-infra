//names
param namingGuid string
param serverName string = 'sqls-${substring(uniqueString(resourceGroup().id, namingGuid), 1, 8)}'
//param sqlDBName string = 'sqldb-${substring(uniqueString(resourceGroup().id, namingGuid), 1, 8)}'
param location string = resourceGroup().location

//required
param sqlDBName string
param adminUsername string
@secure()
param adminPassword string


resource sqlServer 'Microsoft.Sql/servers@2019-06-01-preview' = {
  name: serverName
  location: location
  properties: {
    administratorLogin: adminUsername
    administratorLoginPassword: adminPassword
  }
}

resource sqlDB 'Microsoft.Sql/servers/databases@2020-08-01-preview' = {
  name: '${sqlServer.name}/${sqlDBName}'
  location: location
  sku: {
    name: 'Standard'
    tier: 'Standard'
  }
}

output sqlServerId string = sqlServer.id