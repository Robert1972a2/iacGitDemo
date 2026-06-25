targetScope = 'resourceGroup'

@description('Name of the storage account to create.')
param saName string = 'mystorageaccount'

@description('Location for the storage account.')
@allowed([
  'GermanyWestCentral'
  'NorthEurope'
  'WestEurope'
  'AustriaEast'
])
param location string

resource sa 'Microsoft.Storage/storageAccounts@2026-04-01' = {
  name: saName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
  }
}
