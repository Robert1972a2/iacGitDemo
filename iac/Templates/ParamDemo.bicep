@maxLength(16)
param name string = 'iac-Demo'

@minValue(1)
@maxValue(8)
param qty int = 4

@description('List of IP addresses to allow access from')
param ipAddresses array

@secure()
param adminPassword string

param config object = {
  kind: 'StorageV2'
  sku: 'Standard_LRS'
}

output iacName string = name
output iacQty int = qty
output iacConfig object = config
output iacConfigKind string = config.kind
output iacConfigSku string = config.sku
output iacPWD string = adminPassword
output iacIPs array = ipAddresses
output iacIP1 string = ipAddresses[0]
