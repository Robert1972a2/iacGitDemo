targetScope = 'resourceGroup'

resource existingVNet 'Microsoft.Network/virtualNetworks@2025-05-01' existing = {
  name: 'iac-VNet-Spoke-2'
  scope: resourceGroup('RG-Network-LandingZone')
}

resource NIC 'Microsoft.Network/networkInterfaces@2025-05-01' = {
  dependsOn: [
    existingVNet
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
            id: existingVNet.properties.subnets[indexOf(existingVNet.properties.subnets, { name: 'SubnetTier1' })].id
          }
        }
      }
    ]
  }
}

