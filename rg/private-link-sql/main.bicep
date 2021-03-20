targetScope = 'subscription'

var vnetNamingGuid = 'be541c48-25e9-4c61-8efd-8c184de0295d'
var sqlNamingGuid = '8f3f0a36-4a7f-4dd3-a122-668b703c27dd'

param rgName string

resource rg 'Microsoft.Resources/resourceGroups@2020-06-01' = {
  name: rgName
  location: 'eastus'
}

module createVnet './../../mod/vnet.bicep' = {
  scope: rg
  name: 'createVnet'
  params:{
    namingGuid: vnetNamingGuid
  }
}

module createSql './../../mod/sql.bicep' = {
  scope: rg
  name: 'createSql'
  params: {
    adminUsername: 'mgarner'
    adminPassword: 'Ql4t!bd.7!@#'
    namingGuid: sqlNamingGuid
    sqlDBName: 'SampleDB'
  }
}

// module createPE 'sql-pe.bicep' = {
//   scope: rg
//   name: 'createPE'
//   params: {
//     sqlServerId: createSql.outputs.sqlServerId
//   }
// }

