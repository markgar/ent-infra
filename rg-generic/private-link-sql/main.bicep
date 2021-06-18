targetScope = 'subscription'

param rgName string

param adminUsername string

@secure()
param adminPassword string

var tags = {
  'env': 'sbx'
}
param now string = utcNow()
var vnetId = '/subscriptions/75ebdae9-6e1c-4baa-8b2e-5576f6356a91/resourceGroups/m-shared-vnet/providers/Microsoft.Network/virtualNetworks/vnet-4p7rjz3pg5tyy'
var privateLinkSubnetName = 'privatelink'

resource rg 'Microsoft.Resources/resourceGroups@2020-06-01' = {
  name: rgName
  location: 'eastus'
}

// module createVnet './../../mod/vnet.bicep' = {
//   scope: rg
//   name: 'createVnet-${now}'
//   params: {
//     tags: tags
//   }
// }

module createSql './../../mod/sql.bicep' = {
  scope: rg
  name: 'createSql-${now}'
  params: {
    adminUsername: adminUsername
    adminPassword: adminPassword
    tags: tags
    sqlDBName: 'SampleDB'
  }
}

module createPE './../../mod/sql-pe.bicep' = {
  scope: rg
  name: 'createPE-${now}'
  params: {
    sqlServerId: createSql.outputs.sqlServerId
    dnsZoneName: 'privatelink.database.windows.net'
    vnetId: vnetId
    vnetSubnetId: '${vnetId}\\subnets\\${privateLinkSubnetName}'
    tags: tags
  }
}
