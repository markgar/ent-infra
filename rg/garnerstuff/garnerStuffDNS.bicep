//required
param tags object

resource garnerStuffDns 'Microsoft.Network/dnsZones@2018-05-01' = {
  name: 'garnerstuff.com'
  location: 'global'
  tags: tags
}

resource mcCname 'Microsoft.Network/dnsZones/CNAME@2018-05-01' = {
  name: 'garnerstuff.com/mc'
  properties: {
    TTL: 3600
    CNAMERecord: {
      cname: 'bungeeserver.centralus.cloudapp.azure.com'
    }
  }
}


resource aadDomainTxt 'Microsoft.Network/dnsZones/TXT@2018-05-01' = {
  name: 'garnerstuff.com/@'
  properties: {
    TTL: 3600
    TXTRecords: [
      {
        value:  [
          'MS=ms45259272'
        ]
      }
    ]
  }
}
