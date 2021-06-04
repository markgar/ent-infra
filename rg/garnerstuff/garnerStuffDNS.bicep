//required
param tags object

resource garnerStuffDns 'Microsoft.Network/dnsZones@2018-05-01' = {
  name: 'garnerstuff.com'
  location: 'global'
  tags: tags
}


