# Bicep Basics

**Bicep is Microsoft’s domain-specific language for Azure infrastructure-as-code.** It provides a declarative syntax that is much cleaner and more concise than ARM JSON while compiling directly into ARM templates for deployment. Bicep is designed to make Azure IaC easier to author, maintain, and reuse.

## Quick guide — key considerations before authoring

- **Decide deployment scope**: resource group, subscription, management group, or tenant (`targetScope`).
- **Use strong typing** with `param` declarations to catch issues early and improve IntelliSense.
- **Prefer modules** for reusable components and smaller files.
- **Centralize common values** in `var` declarations, but keep them simple.
- **Avoid manual ARM JSON** unless you need raw ARM output for a platform or policy requirement.

## Why Microsoft recommends Bicep over ARM Templates

- **Cleaner syntax**: Bicep removes much of the JSON boilerplate required by ARM templates.
- **Improved readability**: resource declarations, expressions, and references are easier to scan and understand.
- **Tooling and validation**: the Bicep VS Code extension provides IntelliSense, type checking, syntax highlighting, and live error feedback.
- **Modularity**: Bicep modules are easier to write and compose than linked ARM templates.
- **Native ARM compatibility**: Bicep compiles to standard ARM JSON, so it can be deployed anywhere ARM templates are supported.
- **Microsoft recommendation**: Microsoft positions Bicep as the modern authoring experience for Azure IaC, while ARM JSON remains the underlying deployment artifact.

## Bicep file structure and important parts

A Bicep file is organized around declarative declarations rather than nested JSON objects. Common top-level elements include:

- `targetScope` — defines the deployment scope: `resourceGroup`, `subscription`, `managementGroup`, or `tenant`.
- `param` — declares inputs passed at deployment time.
- `var` — computes values inside the template that are not user-supplied.
- `resource` — declares Azure resources to deploy.
- `module` — references another Bicep file and deploys it as a child scope.
- `output` — returns values after deployment.
- `metadata` — optional descriptions and metadata for parameters and resources.
- `existing` — references resources that already exist without redeploying them.
- `if` / `for` expressions — support conditional deployment and loops.

## `targetScope`

Every Bicep file should start with the deployment scope when the file is intended for direct deployment.

```bicep
targetScope = 'resourceGroup'
```

Use `subscription`, `managementGroup`, or `tenant` for broader deployment scopes.

## Parameters (`param`)

Parameters define the external inputs for a Bicep template. They support types such as `string`, `int`, `bool`, `object`, `array`, `secureString`, and `secureObject`. The syntax for parameters is

```bicep
@<decorator>(<argument>)
param <parameter-name> <parameter-data-type> = <default-value>
```

Examples

```bicep
@description('Deployment environment')
param environment string = 'dev'

@allowed([ 'Standard_LRS', 'Standard_GRS', 'Premium_LRS' ])
param storageAccountSku string = 'Standard_LRS'

```

- Use `@description()` to document parameter purpose.
- Use `@allowed()` to constrain valid values.
- Set defaults for common values, while still allowing overrides during deployment.
- Use apostrophes to enclose stings, not quotation marks.

Common param decorators in Bicep are:

- `@description('text')`
- `@metadata({ ... })`
- `@allowed([ ... ])`
- `@minLength(n)`
- `@maxLength(n)`
- `@minValue(n)`
- `@maxValue(n)`
- `@minItemCount(n)`
- `@maxItemCount(n)`
- `@secure()`

Parameters are used like variables in the bicep file and they can also be self-defined objects:

```bicep
param tags object = {
  owner: 'team-a'
  costCenter: '1234'
}
```

## Variables (`var`)

Variables compute reusable values and keep resource declarations concise.

```bicep
var location = resourceGroup().location
var storageAccountName = toLower('st${uniqueString(resourceGroup().id, environment)}')
var commonTags = union(tags, {
  environment: environment
})
```

- Variables are evaluated during deployment planning and cannot be overridden by users.
- Use them for computed names, merged tags, and API version constants.

---

## Resource declarations

A resource declaration defines an Azure resource in a readable, declarative format.

```bicep
resource storageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: storageAccountSku
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
    supportsHttpsTrafficOnly: true
  }
  tags: commonTags
}
```

- Use `resourceType@apiVersion` syntax.
- Reference other values directly by name.
- Bicep automatically infers many relationships and dependency order.

## Modules

Modules let you break large deployments into smaller reusable pieces.

```bicep
module network 'network.bicep' = {
  name: 'networkDeployment'
  params: {
    environment: environment
  }
}
```

- Modules improve organization and reuse.
- They compile into nested deployments in ARM.

## Outputs

Outputs expose deployment results for scripts, pipelines, or later reference.

```bicep
output storageAccountName string = storageAccount.name
output storageAccountResourceId string = storageAccount.id
```

- Use outputs to return names, resource IDs, connection strings, or other derived values.

## Conditions and loops

Bicep supports conditional and repeated declarations using `if` and `for`.

```bicep
resource optionalStorage 'Microsoft.Storage/storageAccounts@2022-09-01' = if (deployStorage) {
  name: '${storageAccountName}opt'
  location: location
  sku: {
    name: storageAccountSku
  }
  kind: 'StorageV2'
}

var subnetNames = [ 'subnetA', 'subnetB' ]
resource subnets 'Microsoft.Network/virtualNetworks/subnets@2022-09-01' = [for name in subnetNames: {
  name: name
  properties: {
    addressPrefix: '10.0.0.0/24'
  }
}]
```

- `if` enables optional resources.
- `for` creates repeated child resources from arrays.

## Existing resources

Reference resources that already exist without redeploying them.

```bicep
resource existingVnet 'Microsoft.Network/virtualNetworks@2022-09-01' existing = {
  name: 'my-vnet'
}
```

This is useful for retrieving properties or linking new resources to existing infrastructure.

---

### Example Bicep file

```bicep
targetScope = 'resourceGroup'

@description('Deployment environment')
param environment string = 'dev'

@allowed([ 'Standard_LRS', 'Standard_GRS', 'Premium_LRS' ])
param storageAccountSku string = 'Standard_LRS'

param tags object = {
  owner: 'team-a'
  costCenter: '1234'
}

var location = resourceGroup().location
var storageAccountName = toLower('st${uniqueString(resourceGroup().id, environment)}')
var commonTags = union(tags, {
  environment: environment
})

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: storageAccountSku
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
    supportsHttpsTrafficOnly: true
  }
  tags: commonTags
}

output storageAccountName string = storageAccount.name
output storageAccountResourceId string = storageAccount.id
```

## Practical tips and best practices

- **Use Bicep for authoring** and compile to ARM JSON only when needed by external tooling.
- **Keep files focused**: one main deployment per file, with reusable modules for shared logic.
- **Use parameter objects** for grouped settings like tags, network configuration, and credentials.
- **Validate locally** with `bicep build`, `bicep lint`, and `az deployment group validate`.
- **Leverage VS Code** with the Bicep extension for best editing experience.

## Recommended tooling

- **Visual Studio Code + Bicep extension**: IntelliSense, completions, type checking, modules, and decompile.
- **Bicep CLI**: compile `.bicep` files to ARM JSON, generate parameters, and lint templates.
- **Azure CLI / Azure PowerShell**: deploy Bicep files with `az deployment group create` or `New-AzResourceGroupDeployment`.

## Why Bicep matters

Bicep is the modern Azure IaC authoring experience that preserves the full power of ARM while making templates easier to read, write, and maintain. It is the recommended path for new Azure deployments and for teams migrating from ARM JSON to a friendlier, more productive authoring language.
