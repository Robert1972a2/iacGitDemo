# Azure Resource Manager Templates

This is a short description of ARM Templates.

---

Table of Contents

+ [Overview](#overview)
+ [Tools for authoring](#tools-for-authoring)
+ [Schema](#schema)
+ [Parameters](#parameters)
+ [Variables](#variables)
+ [Resource](#resource)
+ [Multiple resources at once](#multiple-resources-at-once)
+ [Conditions](#conditions)
+ [Modularization](#modularization)
+ [Tips and best practices](#tips-and-best-practices)

---

## Overview

ARM Templates arrived with the Azure Resource Manager model (announced 2014), replacing the older “classic” model and introducing **resource groups, role‑based access control, and a consistent management layer**. This made declarative deployments possible and allowed Azure to manage template state and deployments natively. They provide a native, first‑class way to define Azure infrastructure as code, enabling repeatable, auditable, and idempotent deployments. ARM Templates remain important for enterprise governance, automation, and for scenarios where native Azure features (policies, role assignments, template specs) are required. [Microsoft Learn](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/deployment-models)

## Tools for authoring

Recommended tools and how they help

Visual Studio Code + ARM Tools (ARM Templates extension) — Good for direct ARM JSON editing. Offers language support, resource snippets, completions and parameter file support. Note: the ARM Tools extension is in maintenance mode; Microsoft recommends Bicep for new development.

Visual Studio Code + Bicep extension — Best for authoring modern IaC for Azure. Provides IntelliSense, type safety, build (Bicep → ARM), decompile, snippets and a visualizer. Ideal for writing modular, readable templates that compile to ARM JSON.

Azure Portal Template Editor — Quick edits and one‑off deployments. Useful for small changes, previewing templates, and deploying directly from the portal when you need a fast edit/deploy loop.

Azure CLI / Azure PowerShell — Deployment and validation. Use az deployment or New-AzResourceGroupDeployment plus what‑if/validate commands in pipelines to deploy templates and preview changes. (Integrates with VS Code workflows.)

Bicep CLI — Builds and validates Bicep files, emits ARM JSON, and generates parameter files. Use in local dev and CI to produce ARM templates for environments that require raw JSON.

| Tool | Editor Support | Key Features | Best For |
| --- | -------------- | ------------ | -------- |
| VS Code + ARM Tools | VS Code extension | Snippets; ARM JSON completions; parameter support | Direct ARM JSON editing; legacy templates |
| VS Code + Bicep | VS Code extension | IntelliSense; build/decompile; visualizer | Modern authoring; maintainable IaC |
| Azure Portal Editor | Browser | Quick edit & deploy | One‑off edits, demos |
| Azure CLI / PowerShell | CLI | Deploy, validate, what‑if | CI/CD and scripted deployments |
| Bicep CLI | CLI | Compile to ARM; generate params | Build pipelines and validation |

## Schema

An ARM template is a JSON document whose top‑level elements typically include:

+ **$schema** — URL that identifies the ARM template schema and enables editor tooling.  
+ **contentVersion** — template version string.  
+ **parameters** — inputs supplied at deployment time.  
+ **variables** — computed values used inside the template.  
+ **resources** — array of resource objects to deploy.  
+ **outputs** — values returned after deployment.

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {  },
  "variables": {  },
  "resources": [  ],
  "outputs": {  }
}
```

[More information](https://learn.microsoft.com/en-us/azure/azure-resource-manager/templates/syntax)

## Parameters

**Purpose:** accept environment‑specific values at deployment time.

```json
"parameters": {
  "environment": {
    "type": "string",
    "defaultValue": "dev",
    "allowedValues": ["dev", "test", "prod"],
    "metadata": { "description": "Deployment environment" }
  },
  "storageAccountSku": {
    "type": "string",
    "defaultValue": "Standard_LRS",
    "allowedValues": ["Standard_LRS", "Standard_GRS", "Premium_LRS"]
  },
  "adminCredentials": {
    "type": "secureObject",
    "metadata": { "description": "Admin credentials as secure object" }
  },
  "tags": {
    "type": "object",
    "defaultValue": { "owner": "team-a", "costCenter": "1234" }
  }
}
```

**Types**: `string`, `int`, `bool`, `object`, `array`, `secureString`, `secureObject`.  
**Validation**: `allowedValues`, `minLength`, `maxLength`, `minValue`, `maxValue` (where supported).  
**Secure types**: `secureString` and `secureObject` keep sensitive values out of logs.

[More information](https://learn.microsoft.com/en-us/azure/azure-resource-manager/templates/syntax#parameters)

## Variables

**Purpose:** compute reusable values and avoid repetition.

```json
"variables": {
  "location": "[resourceGroup().location]",
  "storageAccountName": "[toLower(concat('st', uniqueString(resourceGroup().id)))]",
  "storageApiVersion": "2022-09-01",
  "commonTags": "[union(parameters('tags'), { 'environment': parameters('environment') })]"
}
```

Use template functions like `concat()`, `uniqueString()`, `toLower()`, `resourceGroup()`, `union()`.  
Variables are evaluated at runtime and cannot be overridden at deployment time.  
Use variables to centralize API versions, computed names, and merged tag sets.

[More information](https://learn.microsoft.com/en-us/azure/azure-resource-manager/templates/syntax#variables)

## Resource

**Purpose:** show a minimal, realistic storage account resource using parameters and variables.

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "environment": { "type": "string", "defaultValue": "dev" },
    "storageAccountSku": { "type": "string", "defaultValue": "Standard_LRS" }
  },
  "variables": {
    "location": "[resourceGroup().location]",
    "storageAccountName": "[toLower(concat('st', uniqueString(resourceGroup().id, parameters('environment'))))]",
    "storageApiVersion": "2022-09-01"
  },
  "resources": [
    {
      "type": "Microsoft.Storage/storageAccounts",
      "apiVersion": "[variables('storageApiVersion')]",
      "name": "[variables('storageAccountName')]",
      "location": "[variables('location')]",
      "sku": { "name": "[parameters('storageAccountSku')]" },
      "kind": "StorageV2",
      "properties": {
        "accessTier": "Hot",
        "supportsHttpsTrafficOnly": true
      },
      "tags": {
        "environment": "[parameters('environment')]"
      }
    }
  ],
  "outputs": {
    "storageAccountName": {
      "type": "string",
      "value": "[variables('storageAccountName')]"
    },
    "storageAccountResourceId": {
      "type": "string",
      "value": "[resourceId('Microsoft.Storage/storageAccounts', variables('storageAccountName'))]"
    }
  }
}
```

**Notes:**

Resources are defined by an array of JSON objects
**Name generation** uses `uniqueString()` to produce a stable, deterministic name scoped to the resource group and vironment.  
**API version** is centralized in a variable for easier updates.  
**Outputs** return the account name and resourceId for downstream use.

[More information](https://learn.microsoft.com/en-us/azure/azure-resource-manager/templates/syntax#resources)

## Multiple resources at once

ARM Templates can deploy multiple similar resources from a single resource definition using the `copy` element instead of manually duplicating blocks.

```json
{
  "type": "Microsoft.Storage/storageAccounts",
  "apiVersion": "2022-09-01",
  "name": "[concat('st', copyIndex())]",
  "location": "[resourceGroup().location]",
  "copy": {
    "name": "storageCopy",
    "count": 3
  },
  "sku": { "name": "[parameters('storageAccountSku')]" },
  "kind": "StorageV2",
  "properties": {
    "accessTier": "Hot"
  }
}
```

+ `copy.count` controls how many instances are created.
+ `copyIndex()` returns the current iteration index.
+ Use arrays and `copyIndex()` to build unique names or property values for each copy.

## Conditions

Use the `condition` property on a resource to deploy it only when an expression evaluates to true.

```json
{
  "condition": "[equals(parameters('deployStorage'), true)]",
  "type": "Microsoft.Storage/storageAccounts",
  "apiVersion": "2022-09-01",
  "name": "[variables('storageAccountName')]",
  "location": "[variables('location')]",
  "sku": { "name": "[parameters('storageAccountSku')]" },
  "kind": "StorageV2",
  "properties": {
    "accessTier": "Hot"
  }
}
```

+ When `condition` is false, the resource is skipped entirely.
+ Conditions are useful for optional infrastructure, environment-specific resources, and feature toggles.

## Modularization

Large ARM templates are easier to manage when broken into smaller nested or linked templates.

```json
{
  "type": "Microsoft.Resources/deployments",
  "apiVersion": "2021-01-01",
  "name": "storageDeployment",
  "properties": {
    "mode": "Incremental",
    "templateLink": {
      "uri": "https://example.com/storage-template.json",
      "contentVersion": "1.0.0.0"
    },
    "parameters": {
      "environment": { "value": "[parameters('environment')]" },
      "storageAccountSku": { "value": "[parameters('storageAccountSku')]" }
    }
  }
}
```

+ Use a nested deployment to split complex logic into separate template files.
+ `templateLink` points to an external ARM JSON file, while `properties.template` can embed a nested template inline.
+ Modularization improves reuse and makes large deployments easier to test and maintain.

## Tips and best practices

**Use objects for grouped parameters** (credentials, tags, network settings) to reduce parameter count.  
**Centralize API versions** in variables or linked templates to simplify upgrades.  
**Validate locally** with `az deployment group validate` or `what‑if` to preview changes.  
**Modularize** large templates into nested or linked templates or use template specs for reuse.  
**Prefer readable names** and deterministic naming patterns (uniqueString, concat) to avoid collisions.  
**Consider Bicep** for authoring and then compile to ARM JSON if you want cleaner syntax with full ARM compatibility.

**Azure Resource Manager (ARM) Templates are JSON‑based declarative files that let you define Azure infrastructure as code for repeatable, auditable deployments; they were introduced with the ARM deployment model in 2014 and remain a native, first‑class IaC option in Azure.**   [Microsoft Learn](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/deployment-models)

Key considerations before authoring

**Decide scope** (resource group, subscription, management group, tenant).  
**Choose declarative modules** for repeatability and idempotency.  
**Plan parameters and defaults** to reuse templates across environments.  
**Consider Bicep** if you want a cleaner authoring experience that compiles to ARM JSON.   [Microsoft Learn](https://learn.microsoft.com/en-us/azure/azure-resource-manager/templates/)  [Microsoft Learn](https://learn.microsoft.com/en-us/azure/azure-resource-manager/templates/syntax)
