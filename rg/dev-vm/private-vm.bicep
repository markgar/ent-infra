//names
param disambiguationPhrase string = ''
param storageAccountName string = 'stg${disambiguationPhrase}${uniqueString(subscription().id, resourceGroup().id)}'
param nicName string = 'nic-${disambiguationPhrase}${uniqueString(subscription().id, resourceGroup().id)}'
param publicIPAddressName string = 'pip-${disambiguationPhrase}${uniqueString(subscription().id, resourceGroup().id)}'
param vmName string = 'vm-${disambiguationPhrase}${uniqueString(subscription().id, resourceGroup().id)}'

@description('location for all resources')
param location string = resourceGroup().location

//required
param vmSubnetId string
param tags object
param createAsPublic bool = true
param adminUsername string
@secure()
param adminPassword string

//options
@allowed([
  '2008-R2-SP1'
  '2012-Datacenter'
  '2012-R2-Datacenter'
  '2016-Nano-Server'
  '2016-Datacenter-with-Containers'
  '2016-Datacenter'
  '2019-Datacenter'
])
@description('The Windows version for the VM. This will pick a fully patched image of this given Windows version.')
param windowsOSVersion string = '2019-Datacenter'

@description('Size of the virtual machine.')
param vmSize string

resource stg 'Microsoft.Storage/storageAccounts@2019-06-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'Storage'
  tags: tags
}

resource pip 'Microsoft.Network/publicIPAddresses@2020-06-01' =  if (createAsPublic) {
  name: publicIPAddressName
  location: location
  properties: {
    publicIPAllocationMethod: 'Dynamic'
    dnsSettings: {
      domainNameLabel: vmName
    }
  }
  tags: tags
}

resource nic 'Microsoft.Network/networkInterfaces@2020-06-01' = {
  name: nicName
  location: location

  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: createAsPublic ? {
            id: pip.id
          }
          subnet: {
            id: vmSubnetId
          }
        }
      }
    ]
  }
  tags: tags
}

resource VM 'Microsoft.Compute/virtualMachines@2020-06-01' = {
  name: vmName
  location: location
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    osProfile: {
      computerName: substring(vmName,3,13) //strips off the 'vm-' so the vm name is short enough
      adminUsername: adminUsername
      adminPassword: adminPassword
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: windowsOSVersion
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nic.id
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
        storageUri: stg.properties.primaryEndpoints.blob
      }
    }
  }
  tags: tags
}

resource offSched 'Microsoft.DevTestLab/schedules@2018-09-15' = {
  name: 'shutdown-computevm-${vmName}'
  location: location
  properties: {
    status: 'Enabled'
    taskType: 'ComputeVmShutdownTask'
    dailyRecurrence: {
      time: '2100'
    }
    timeZoneId: 'Central Standard Time'
    notificationSettings: {
      status: 'Disabled'
    }
    targetResourceId: VM.id
  }
  tags: tags
}

//output hostname string = pip.properties.dnsSettings.fqdn
