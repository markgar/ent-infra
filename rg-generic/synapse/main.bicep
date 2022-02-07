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

module deployStorage 'storage.bicep' = {
  scope: rg
  name: 'deployStorage'
  params: {
    tags: tags
  }
}
