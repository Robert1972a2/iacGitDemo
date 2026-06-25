using './ParamDemo.bicep'

param name = 'iac-Demo'
param qty = 4
param ipAddresses = [
  '192.168.0.0'
  '192.168.1.0'
  '192.168.2.0'
]

param adminPassword = 'Passw0rd!'

param config = {
  kind: 'StorageV2'
  sku: 'Standard_LRS'
}
