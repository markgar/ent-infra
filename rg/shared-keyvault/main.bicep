targetScope = 'subscription'

param rgName string

var tags = {
  'env': 'sbx'
}
param now string = utcNow()

resource rg 'Microsoft.Resources/resourceGroups@2020-06-01' = {
  name: rgName
  location: 'eastus'
}

module createKeyVault './../../mod/keyvault.bicep' = {
  scope: rg
  name: 'createKeyVault-${now}'

  params: {
    tags: tags
    softDeleteRetentionInDays: 90
  }
}
