//names
param disambiguationPhrase string = ''
param storageAccountName string = 'stg${disambiguationPhrase}${uniqueString(subscription().id, resourceGroup().id)}'

param location string = resourceGroup().location

//required
param tags object

resource storage 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: storageAccountName
  location: location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
    tier: 'Standard'
  }
  tags: tags
}

resource fileshareService 'Microsoft.Storage/storageAccounts/fileServices@2021-02-01' = {
  name: '${storageAccountName}/default'
}

resource fileshare 'Microsoft.Storage/storageAccounts/fileServices/shares@2021-02-01' = {
  name: '${storageAccountName}/default/myshare'
}
