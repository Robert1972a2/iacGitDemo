targetScope = 'resourceGroup'

resource dscript 'Microsoft.Resources/deploymentScripts@2023-08-01' = {
  kind: 'AzurePowerShell'
  name: 'dscriptdemo'
  location: 'North Europe'
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '/subscriptions/097d177e-53e4-4f46-8807-96576bb5dde0/resourcegroups/RG-Mgmt/providers/Microsoft.ManagedIdentity/userAssignedIdentities/iac-uami': {}
    }
  }
  properties: {
    azPowerShellVersion: '14.0'
    scriptContent: '''
      Write-Output "The deployment script is running ..."
      Start-Sleep -Seconds 60
      $DeploymentScriptOutputs['result'] = 'Success'
    '''
    timeout: 'PT45M'
    cleanupPreference: 'OnExpiration'
    retentionInterval: 'PT1H'
    
    containerSettings: {
      containerGroupName: 'iac-ContainerGroup'
    }
    environmentVariables: [
      {
        name: 'iacEnvVariable'
        value: 'Infrastructure as Code'
      }
    ]
  }
}

output deploymentScriptResult string = dscript.properties.outputs.result
