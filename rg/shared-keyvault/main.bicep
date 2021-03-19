targetScope = 'subscription'

var namingGuid = '681a7143-1a0a-4ad2-a718-b0eda69d29ff'

param rgName string

resource rg 'Microsoft.Resources/resourceGroups@2020-06-01' = {
  name: rgName
  location: 'eastus'
}

module createKeyVault './../../mod/keyvault.bicep' = {
  scope: rg
  name: 'createKeyVault'
  params: {
    namingGuid: namingGuid
  }
}