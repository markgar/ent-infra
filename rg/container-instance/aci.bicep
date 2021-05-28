//names
param disambiguationPhrase string = ''
param aciName string = 'aci${disambiguationPhrase}${uniqueString(subscription().id, resourceGroup().id)}'
param vnetName string
param vnetResourceGroupName string
param subnetName string

param location string = resourceGroup().location

//required
param tags object

resource subnetRef 'Microsoft.Network/virtualNetworks/subnets@2020-11-01' existing = {
  name: '${vnetName}/${subnetName}'
  scope: resourceGroup(vnetResourceGroupName)
}

resource aciSubnetNetworkProfile 'Microsoft.Network/networkProfiles@2020-05-01' = {
  name: 'aciNetworkProfile'
  location: location
  properties: {
    containerNetworkInterfaceConfigurations: [
      {
        name: 'nicConfiguration'
        properties: {
          ipConfigurations: [
            {
              name: 'ipconfig'
              properties: {
                subnet: {
                  id: subnetRef.id
                } 
              }
            }
          ]
        }
      }
    ]
  }
}

resource storage 'Microsoft.ContainerInstance/containerGroups@2019-12-01' = {
  name: aciName
  location: location
  properties: {
    containers: [
      {
        name: 'testcontainer'
        properties: {
          image: 'microsoft/aci-helloworld'
          ports: [
            {
              port: 80
              protocol: 'TCP'
            }
          ]
          resources: {
            requests: {
              cpu: 1
              memoryInGB: 1
            }
          }
        }
      }
    ]
    osType: 'Linux'
    networkProfile: {
      id: aciSubnetNetworkProfile.id
    }
  
    // ipAddress: {
    //   type: 'Public'
    //   ports: [
    //     {
    //       port: 80
    //       protocol: 'TCP'
    //     }
    //   ]
    // }
  }
}
