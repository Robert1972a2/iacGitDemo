targetScope = 'resourceGroup'

@description('Number of log analytics workspaces to create.')
param LAWSNames array = ['iacLAWS-1','iacLAWS-2']

resource iac_workspaces 'Microsoft.OperationalInsights/workspaces@2023-09-01' = [
  for LAWSName in LAWSNames : {
    name: LAWSName
    location: resourceGroup().location
    properties: {
      sku: {
        name: 'PerGB2018'
      }
    }
  }
]
