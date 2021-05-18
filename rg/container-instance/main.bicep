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


module createStorage 'aci.bicep' = {
  scope: rg
  name: 'createAci-${now}'
  params: {
    tags: tags
  }
}
