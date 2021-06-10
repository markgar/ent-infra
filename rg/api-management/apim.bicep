//names
param disambiguationPhrase string = ''
param apimName string = 'apim-${disambiguationPhrase}${uniqueString(subscription().id, resourceGroup().id)}'

param location string = resourceGroup().location

//required
param tags object

resource apim 'Microsoft.ApiManagement/service@2020-12-01' = {
  name: apimName
  location: location
  sku: {
    capacity: 1
    name: 'Basic'
  }
  properties: {
    publisherEmail: 'mgarner@microsoft.com'
    publisherName: 'Mark Garner'
  }
  tags: tags
}
