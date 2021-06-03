//names
param disambiguationPhrase string = ''
param cosmosAccountName string = 'cacct-${disambiguationPhrase}${uniqueString(subscription().id, resourceGroup().id)}'

param location string = resourceGroup().location

//required
param tags object

resource cosmosAccount 'Microsoft.DocumentDB/databaseAccounts@2021-04-15' = {
  name: cosmosAccountName
  properties: {
    databaseAccountOfferType: 'Standard'
    locations: [
      {
        locationName: location
      }
    ]
  }
  tags: tags
}
