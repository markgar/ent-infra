targetScope = 'subscription'

var namingGuid = 'cbcc3a4d-92d7-41ed-99a1-a4876adcbb31'

param rgName string

resource rg 'Microsoft.Resources/resourceGroups@2020-06-01' = {
  name: rgName
  location: 'eastus'
}

module createKeyVault './../../mod/vnet.bicep' = {
  name: 'createVnet'
  scope: rg
  params: {
    namingGuid: namingGuid
  }
}