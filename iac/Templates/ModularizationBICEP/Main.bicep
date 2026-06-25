targetScope = 'resourceGroup'

module AutomationAccount './ModuleAutoAccount.bicep' = {
  name: 'iac-AutomationAccount-Module'
  params: {
    AutomationAccountName: 'iac-AutomationAccount'
  }
  dependsOn: []
} 

