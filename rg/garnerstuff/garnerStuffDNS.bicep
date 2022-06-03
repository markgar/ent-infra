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
          'v=spf1 include:spf.protection.outlook.com -all'
        ]
      }
    ]
  }
}

resource autodiscoverCname 'Microsoft.Network/dnsZones/CNAME@2018-05-01' = {
  name: 'garnerstuff.com/autodiscover'
  properties: {
    TTL: 3600
    CNAMERecord: {
      cname: 'autodiscover.outlook.com'
    }
  }
}


resource mx 'Microsoft.Network/dnsZones/MX@2018-05-01' = {
  name: 'garnerstuff.com/@'
  properties: {
    TTL: 3600
    MXRecords: [
      {
        exchange: 'garnerstuff-com.mail.protection.outlook.com'
      }
    ]
  }
}
