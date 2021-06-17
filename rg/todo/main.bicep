targetScope = 'subscription'

param rgName string

var tags = {
  'env': 'dev'
}

param now string = utcNow()

resource rg 'Microsoft.Resources/resourceGroups@2020-06-01' = {
  name: rgName
  location: 'eastus'
}

module createAppService 'app-service.bicep' = {
  scope: rg
  name: 'createAppService-${now}'
  params: {
    tags: tags
  }
}

module createCosmos 'cosmosDb.bicep' = {
  scope: rg
  name: 'createCosmos-${now}'
  params: {
    tags: tags
  }
}

// test//
