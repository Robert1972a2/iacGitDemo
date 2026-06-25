@description('Storage Account Name')
param saName string

resource sa 'Microsoft.Storage/storageAccounts@2025-06-01' = {
  name: saName
  location: 'North Europe'
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
}

resource vnet 'Microsoft.Network/virtualNetworks@2025-05-01' = {
  name: 'iac-VNet'
  location: 'North Europe'
  properties: {
    addressSpace: {
      addressPrefixes: [
        '172.16.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'subnet1'
        properties: {
          addressPrefix: '172.16.0.0/24'
        }
      }
      {
        name: 'subnet2'
        properties: {
          addressPrefix: '172.16.1.0/24'
        }
      }
    ]
  }
}

resource nic1 'Microsoft.Network/networkInterfaces@2025-05-01' = {
  name: 'iac-NIC-1'
  location: 'North Europe'
  dependsOn: [
     vnet
  ]
  properties: {
      ipConfigurations: [
        {
          name: 'MainConfiguration'
          properties: {
            privateIPAllocationMethod: 'Dynamic'
            subnet: {
              id: resourceId('Microsoft.Network/virtualNetworks/subnets', vnet.name, 'subnet1')
            }
            }
        }
      ]
  }
}
