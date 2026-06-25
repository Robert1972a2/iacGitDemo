targetScope = 'resourceGroup'

param DomainName string = 'demo.local'
param VNetName string

resource privDns 'Microsoft.Network/privateDnsZones@2024-06-01' = {
  name: DomainName
  location: 'Global'
  properties: {}
}

resource vnetLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2024-06-01' = {
  parent: privDns
  location: 'Global'
  name: 'linked-to-${VNetName}'
  properties: {
    registrationEnabled: true
    // resolutionPolicy: 'string'
    virtualNetwork: {
      id: VNet.id
    }
  }
}

resource dnsrecorda 'Microsoft.Network/privateDnsZones/A@2024-06-01' = {
  parent: privDns
  name: 'test-a'
  properties: {
    ttl: 3600
    aRecords: [
      {
        ipv4Address: '9.6.3.1'
      }
    ]
  }
}

resource dnsrecordcname 'Microsoft.Network/privateDnsZones/CNAME@2024-06-01' = { 
  parent: privDns
  name: 'test-b'
  properties: {
    ttl: 3600
    cnameRecord: {
      cname: 'www.iac.net'
    }
  }
}

resource VNet 'Microsoft.Network/virtualNetworks@2025-07-01' existing = {
  name: VNetName
}

output VNetID string = VNet.id
