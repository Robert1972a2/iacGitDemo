targetScope = 'resourceGroup'

@description('Number of log analytics workspaces to create.')
param LAWSCount int = 2

resource iac_workspaces 'Microsoft.OperationalInsights/workspaces@2023-09-01' = [
  for i in range(0, LAWSCount): {
    name: 'iac-workspace-${(i+1)}'
    location: resourceGroup().location
    properties: {
      sku: {
        name: 'PerGB2018'
      }
    }
  }
]


/*
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
*/
