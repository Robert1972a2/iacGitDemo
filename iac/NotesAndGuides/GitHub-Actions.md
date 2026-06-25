# Steps to create a GitHub Actions Workflow

---

Table of contents

- [Steps to create a GitHub Actions Workflow](#steps-to-create-a-github-actions-workflow)
  - [Authentication Configuration](#authentication-configuration)
    - [OIDC](#oidc)
    - [Service Principal Credentials](#service-principal-credentials)
  - [Create Workflow](#create-workflow)
  - [Run workflow](#run-workflow)

 ---

## Authentication Configuration

### OIDC

1. Configure SP ( App Registration )
1. Note the following

    ```json
    {
        "clientId": "<yourAppId>",
        "subscriptionId": "<yourSubscriptionID>",
        "tenantId": "<yourTenantID>"
    }
    ```

1. Assign permissions to that SP in Azure.
1. Create or use an Environment in GitHub: Repo -> Settings -> Environments.
1. In the Environment, create three variables: Client_ID, Subscription_ID, Tenant_ID
1. Use the following in your workflow for authentication:

  ```yaml
    name: IaC - VNet - OIDC

    on:
      workflow_dispatch:

    permissions:
      id-token: write
      contents: read

    # A workflow run is made up of one or more jobs that can run sequentially or in parallel
    jobs:
      # This workflow contains a single job called "deployVNet"
      deployVNet:
        # The type of runner that the job will run on
        runs-on: ubuntu-latest
        environment:
          name: <yourEnvironmentName>

        # Steps represent a sequence of tasks that will be executed as part of the job
        steps:
          - name: RepoCheckout
            uses: actions/checkout@v6.0.0
            
          - name: Azure Login
            uses: Azure/login@v3
            with:
              client-id: ${{ vars.CLIENT_ID }}
              tenant-id: ${{ vars.TENANT_ID }}
              subscription-id: ${{ vars.SUBSCRIPTION_ID }}
  ```

### Service Principal Credentials

1. Confige SP ( App Registration ) + Secret
1. Note the following

    ```json
    {
        "clientId": "<yourAppId>",
        "clientSecret": "<yourSecret>",
        "subscriptionId": "<yourSubscriptionID>",
        "tenantId": "<yourTenantID>"
    }
    ```

1. Instead of a secret or certificate configure Federation.
1. Assign permissions to that SP in Azure.
1. Create a Secret in GitHub: Repo -> Settings -> Secrets and variables -> Actions -> New Repository Secret
1. In your workflow use the following settings for authentication:

    ```yaml
    name: IaC - VNet - OIDC

    on:
      workflow_dispatch:

    # A workflow run is made up of one or more jobs that can run sequentially or in parallel
    jobs:
      # This workflow contains a single job called "deployVNet"
      deployVNet:
        # The type of runner that the job will run on
        runs-on: ubuntu-latest

        # Steps represent a sequence of tasks that will be executed as part of the job
        steps:
          - name: RepoCheckout
            uses: actions/checkout@v6.0.0
            
          - name: Azure Login
            uses: Azure/login@v3
            with:
              creds: ${{ secrets.AZ_IAC_SP }}

    ```

## Create Workflow

Create workflow in GitHub portal or Visual Studio Code. Save your workflow file (*.yml) in `./.github/workflows`. The name of the workflow is defined in the yaml file at the beginning with `name:` and not the filename. This name will you see in the portal later. Commit and push it to your repository.

```yaml
# This is a basic workflow that is manually triggered

name: IaC - VNet

# Controls when the action will run. Workflow runs when manually triggered using the UI
# or API.
on:
  workflow_dispatch:
   

# A workflow run is made up of one or more jobs that can run sequentially or in parallel
jobs:
  # This workflow contains a single job called "deployVNet"
  deployVNet:
    # The type of runner that the job will run on
    runs-on: ubuntu-latest

    # Steps represent a sequence of tasks that will be executed as part of the job
    steps:
      - name: RepoCheckout
        uses: actions/checkout@v6.0.0
        
      - name: Azure Login
        uses: Azure/login@v3
        with:
          creds: ${{ secrets.AZ_IAC_SP }}

      - name: DeployBicep
        uses: Azure/bicep-deploy@v2.3.0
        with:
          # Specifies the execution type, which can be either 'deployment' or 'deploymentStack'.
          type: deployment
          # Specifies the Azure subscription ID to which the deployment will be applied.
          subscription-id: 097d177e-53e4-4f46-8807-96576bb5dde0
          # Specifies the operation to perform. For deployment, choose from 'create', 'validate', 'whatIf'. For deploymentStack, choose from 'create', 'delete', 'validate'.
          operation: create
          # Specifies the scope of the deployment or deploymentStack. For deployment, choose from 'resourceGroup', 'subscription', 'managementGroup', 'tenant'. For deploymentStack, choose from 'resourceGroup', 'subscription', 'managementGroup'.
          scope: resourceGroup 
          # Specifies the name of the deployment or deploymentStack.
          name: <yourDeploymentName>
          # Specifies the resource group name. Required if the 'scope' parameter is 'resourceGroup'.
          resource-group-name: <yourResourceGroupName>
          # Specifies the path to the template file.
          template-file: ./.biceps/VNet.bicep

```

## Run workflow

In GitHub portal navigate to your repo and there to Actions. Select your workflow and click `Run workflow`.
