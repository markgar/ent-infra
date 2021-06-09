targetScope = 'subscription'

param rgName string
param env string

var tags = {
  'env': 'dev'
}

param now string = utcNow()

resource rg 'Microsoft.Resources/resourceGroups@2020-06-01' = {
  name: 'm-${rgName}-${env}'
  location: 'eastus'
}

module createAPIManagement 'apim.bicep' = {
  scope: rg
  name: 'createAPIManagement-${now}'
  params: {
    tags: tags
  }
}

