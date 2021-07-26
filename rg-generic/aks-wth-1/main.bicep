@description('Globally Unique Prefix')
param resourcePrefix string = 'wth'

@description('User name for the Virtual Machine.')
param adminUsername string

@description('Password for the Virtual Machine.')
@secure()
param adminPassword string

@description('The Ubuntu version for the VM. This will pick a fully patched image of this given Ubuntu version. Allowed values: 12.04.5-LTS, 14.04.2-LTS, 15.10.')
@allowed([
  '12.04.5-LTS'
  '14.04.2-LTS'
  '15.10'
  '16.04-LTS'
  '18.04-LTS'
])
param ubuntuOSVersion string = '18.04-LTS'

@description('Address Prefix')
param vnetPrefix string = '10.0.0.0/16'

@description('Subnet Name')
param subnetName string = 'Default'

@description('Subnet Prefix')
param subnetPrefix string = '10.0.0.0/24'

@description('URI for the script file to be used to set up the Linux VM')
param scriptUri string

@description('The name of the script file to be used to set up the Linux VM')
param scriptName string

var vnetName_var = '${resourcePrefix}-VNET'
var nsgName_var = '${resourcePrefix}-NSG'
var nicName_var = '${resourcePrefix}-VM-NIC'
var vmName_var = '${resourcePrefix}-docker-build-VM'
var publicIPAddressName_var = '${resourcePrefix}-PIP'
var publicIPAddressType = 'Dynamic'
var dnsNameForPublicIP = '${resourcePrefix}${uniqueString(resourceGroup().id)}-pip'
var subnetRef = '${vnetName.id}/subnets/${subnetName}'
var vmSize = 'Standard_DS2_v2'
var imagePublisher = 'Canonical'
var imageOffer = 'UbuntuServer'
var extensionName = 'vmSetupScript'
var sshPort = '2266'

resource nsgName 'Microsoft.Network/networkSecurityGroups@2021-02-01' = {
  name: nsgName_var
  location: resourceGroup().location
  properties: {
    securityRules: [
      {
        name: 'ssh_rule'
        properties: {
          description: 'Allow SSH'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: sshPort
          sourceAddressPrefix: 'Internet'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 100
          direction: 'Inbound'
        }
      }
      {
        name: 'allow-app-endpoints'
        properties: {
          description: 'allow-app-endpoints'
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '3000-3010'
          sourceAddressPrefix: 'Internet'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 101
          direction: 'Inbound'
        }
      }
    ]
  }
}

resource vnetName 'Microsoft.Network/virtualNetworks@2021-02-01' = {
  name: vnetName_var
  location: resourceGroup().location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetPrefix
      ]
    }
    subnets: [
      {
        name: subnetName
        properties: {
          addressPrefix: subnetPrefix
          networkSecurityGroup: {
            id: nsgName.id
          }
        }
      }
    ]
  }
}

resource publicIPAddressName 'Microsoft.Network/publicIPAddresses@2021-02-01' = {
  name: publicIPAddressName_var
  location: resourceGroup().location
  properties: {
    publicIPAllocationMethod: publicIPAddressType
    dnsSettings: {
      domainNameLabel: dnsNameForPublicIP
    }
  }
}

resource nicName 'Microsoft.Network/networkInterfaces@2021-02-01' = {
  name: nicName_var
  location: resourceGroup().location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIPAddressName.id
          }
          subnet: {
            id: subnetRef
          }
        }
      }
    ]
  }
}

resource vmName 'Microsoft.Compute/virtualMachines@2021-03-01' = {
  name: vmName_var
  location: resourceGroup().location
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    osProfile: {
      computerName: vmName_var
      adminUsername: adminUsername
      adminPassword: adminPassword
    }
    storageProfile: {
      imageReference: {
        publisher: imagePublisher
        offer: imageOffer
        sku: ubuntuOSVersion
        version: 'latest'
      }
      osDisk: {
        name: 'osdisk'
        caching: 'ReadWrite'
        createOption: 'FromImage'
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nicName.id
        }
      ]
    }
  }
}

resource vmName_extensionName 'Microsoft.Compute/virtualMachines/extensions@2021-03-01' = {
  parent: vmName
  name: extensionName
  location: resourceGroup().location
  properties: {
    publisher: 'Microsoft.Azure.Extensions'
    type: 'CustomScript'
    typeHandlerVersion: '2.0'
    autoUpgradeMinorVersion: true
    settings: {
      fileUris: [
        scriptUri
      ]
    }
    protectedSettings: {
      commandToExecute: 'sh ${scriptName} ${adminUsername}'
    }
  }
}

output instanceView object = vmName_extensionName.properties.instanceView
