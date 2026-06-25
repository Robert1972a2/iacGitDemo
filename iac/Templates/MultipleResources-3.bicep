targetScope = 'resourceGroup'

var myVar = [
  {
    sku: 'Free'
    location: 'AustriaEast'
  }
  {
    sku: 'Basic'
    location: 'NorthEurope'
  }
]

resource iac_AutoAccount 'Microsoft.Automation/automationAccounts@2024-10-23' = [
  for (accountconfig,i) in myVar: {
  name: 'iac-AutoAccount-${(i+1)}'
  location: accountconfig.location
  properties: {
    sku: {
      name: accountconfig.sku
    }
  }
}]
