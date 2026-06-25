targetScope = 'resourceGroup'

resource NIC 'Microsoft.Network/networkInterfaces@2025-05-01' = {
  dependsOn: [
    VNetSpoke2
  ]
  name: 'iac-NIC-1'
  location: resourceGroup().location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: VNetSpoke2.properties.subnets[0].id
          }
        }
      }
    ]
  }
}

resource VNetSpoke2 'Microsoft.Network/virtualNetworks@2020-11-01' = {
  name: 'iac-VNet-Spoke-2'
  location: resourceGroup().location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.110.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'SubnetTier1'
        properties: {
          addressPrefix: '10.110.0.0/24'
        }
      }
      {
        name: 'SubnetTier2'
        properties: {
          addressPrefix: '10.110.1.0/24'
        }
      }
    ]
  }
}
