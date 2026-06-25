@maxLength(4)
param Prefix string = 'iac'

@maxLength(15)
param VMName string = 'VM'

var fullVMName = '${Prefix}-${VMName}'
var fullVNetName = '${Prefix}-VNet'
var fullNICName = '${Prefix}-NIC'
var fullPubIPName = '${Prefix}-PubIP'
var fullNSGName = '${Prefix}-NSG'
var fullOSDiskName = '${Prefix}-OSDisk-${VMName}'
var fullShutdownConfigName = 'shutdown-computevm-${fullVMName}'

resource autoshutdown 'microsoft.devtestlab/schedules@2018-09-15' = {
  name: fullShutdownConfigName
  location: resourceGroup().location
  properties: {
    status: 'Enabled'
    taskType: 'ComputeVmShutdownTask'
    dailyRecurrence: {
      time: '2100'
    }
    timeZoneId: 'W. Europe Standard Time'
    notificationSettings: {
      status: 'Enabled'
      timeInMinutes: 30
      emailRecipient: 'admin@trg.dist.at'
      notificationLocale: 'en'
    }
    targetResourceId: VM.id
  }
}


resource VM 'Microsoft.Compute/virtualMachines@2025-11-01' = {
  name: fullVMName
  location: resourceGroup().location
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_D2s_v6'
    }
    osProfile: {
      computerName: VMName
      adminUsername: 'localadmin'
      adminPassword: 'P@ssw0rd1234!'
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2025-Datacenter-g2'
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
        name: fullOSDiskName
        managedDisk: {
          storageAccountType: 'StandardSSD_LRS'
        }
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: NIC.id
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: false
      }
    }
  }
}

resource NIC 'Microsoft.Network/networkInterfaces@2025-05-01' = {
  name: fullNICName
  location: resourceGroup().location
  tags: {
    Author: 'DIST'
    Course: 'IaC'
  }
  properties: {
    ipConfigurations: [
      {
        name: 'ipConfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: resourceId('Microsoft.Network/virtualNetworks/subnets', fullVNetName, 'Subnet-1')
          }
        }
      }
    ]
  }
  dependsOn: [
    VNet
    PubIP
  ]
}

resource VNet 'Microsoft.Network/virtualNetworks@2025-05-01' = {
  name: fullVNetName
  location: resourceGroup().location
  tags: {
    Author: 'DIST'
    Course: 'IaC'
  }
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.101.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'Subnet-1'
        properties: {
          addressPrefix: '10.101.0.0/24'
          networkSecurityGroup: {
            id: NSG.id
          }
        }
      }
      {
        name: 'Subnet-2'
        properties: {
          addressPrefix: '10.101.1.0/24'
          networkSecurityGroup: {
            id: NSG.id
          }
        }
      }
    ]
  }
}

resource PubIP 'Microsoft.Network/publicIPAddresses@2025-05-01' = {
  name: fullPubIPName
  location: resourceGroup().location
  tags: {
    Author: 'DIST'
    Course: 'IaC'
  }
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
    publicIPAddressVersion: 'IPv4'
  }
}

resource NSG 'Microsoft.Network/networkSecurityGroups@2025-05-01' = {
  name: fullNSGName
  location: resourceGroup().location
  properties: {
    securityRules: [
      {
        name: 'RDP-Allow'
        properties: {
          description: 'Allow RDP traffic'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '3389'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 500
          direction: 'Inbound'
        }
      }
    ]
  }
}
