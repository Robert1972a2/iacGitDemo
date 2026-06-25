targetScope = 'subscription'

@description('Name of the resource group to create.')
param rgName string

@description('Location for the resource group.')
@allowed([
  'GermanyWestCentral'
  'NorthEurope'
  'WestEurope'
  'AustriaEast'
])
param location string

resource rg 'Microsoft.Resources/resourceGroups@2024-11-01' = {
  name: rgName
  location: location
  properties: {}
}

output resourceGroupName string = rgName
output resourceGroupLocation string = location
