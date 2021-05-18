//names
param disambiguationPhrase string = ''
param aciName string = 'aci${disambiguationPhrase}${uniqueString(subscription().id, resourceGroup().id)}'

param location string = resourceGroup().location

//required
param tags object

resource storage 'Microsoft.ContainerInstance/containerGroups@2021-03-01' = {
  name: aciName
  location: location
properties: {
  
}
}
