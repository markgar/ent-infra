//names
param disambiguationPhrase string = ''
param aksName string = 'aks-${disambiguationPhrase}${uniqueString(subscription().id, resourceGroup().id)}'

param location string = resourceGroup().location

//required
param tags object
param vnetSubnetId string
param aksSPClientId string
param aksSPSecret string

resource aks 'Microsoft.ContainerService/managedClusters@2021-02-01' = {
  name: aksName
  location: location
  properties: {
    dnsPrefix: aksName
    
    networkProfile: {
      networkPlugin: 'azure'
      serviceCidr: '10.0.254.0/24'
      dockerBridgeCidr: '172.17.0.1/16'
      dnsServiceIP: '10.0.254.10'
    }
    agentPoolProfiles: [
      {
        name: 'pool1'
        osDiskSizeGB: 128
        osType: 'Linux'
        count: 1
        vnetSubnetID: vnetSubnetId
        vmSize: 'Standard_D2_v2'
        mode: 'System'
      }
    ]
    servicePrincipalProfile: {
      clientId: aksSPClientId
      secret: aksSPSecret
    }
  }
}
