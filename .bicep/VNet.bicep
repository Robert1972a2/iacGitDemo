resource IaC_VNet_Spoke_2 'Microsoft.Network/virtualNetworks@2024-05-01' = {
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
