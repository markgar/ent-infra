//names
param disambiguationPhrase string = ''
param storageName string = 'stg-${disambiguationPhrase}${uniqueString(subscription().id, resourceGroup().id)}'


param location string = resourceGroup().location

//required
param tags object

resource myStorage 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: storageName
  location: location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
  properties: {
    isHnsEnabled: true
  }
}

resource dlProperties  'Microsoft.Storage/storageAccounts/blobServices/containers@2021-06-01' = {
  name: '${storageName}/default/lake'
}

