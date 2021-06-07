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

module createStorage 'storage.bicep' = {
  scope: rg
  name: 'createStorage-${now}'
  params: {
    tags: tags
  }
}
