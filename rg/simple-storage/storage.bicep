param tags object

resource storage 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: 'lkasdfjkl'
  location: resourceGroup().location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
    tier: 'Standard'
  }
  tags: tags
}
