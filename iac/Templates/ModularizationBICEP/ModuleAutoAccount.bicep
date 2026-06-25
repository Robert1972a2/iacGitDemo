targetScope = 'resourceGroup'

param AutomationAccountName string = 'iac-AutomationAccount'

resource AutoAccount 'Microsoft.Automation/automationAccounts@2024-10-23' = {
  name: AutomationAccountName
  location: resourceGroup().location
  properties: {
    sku: {
      name: 'Free'
    }
  }
}
