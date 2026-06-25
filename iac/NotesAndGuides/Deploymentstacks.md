# Deployment Stacks

+ [What is a deployment stack?](#what-is-a-deployment-stack)
+ [Benefits of deployment stacks](#benefits-of-deployment-stacks)
+ [Deployment stack resources](#deployment-stack-resources)
+ [Deployment stack operations](#deployment-stack-operations)
  + [Deny Settings](#deny-settings)
  + [Detachment and deletion](#detachment-and-deletion)
+ [Examples woking with deployment stacks](#examples-woking-with-deployment-stacks)
  + [Introduction](#introduction)
  + [Create](#create)
  + [List](#list)
  + [Update](#update)
  + [Remove](#remove)
+ [Links](#links)

## What is a deployment stack?

An Azure deployment stack is a type of Azure resource that enables you to manage the lifecycle of a collection of Azure resources as a single atomic unit, even if they span multiple resource groups or subscriptions. It allows for consistent and repeatable deployments, simplifies management, and enables efficient scaling and updating of resources. [^1]

A deployment stack allows you to group all the resources that make up your application, regardless of where they are in your Azure resource organizational hierarchy. You can manage them as a single unit. With deployment stacks, you're able to perform lifecycle operations on the collection of resources that make up the stack. [^1]

## Benefits of deployment stacks

There are many benefits that deployment stacks can add to your resource provisioning process, including [^2]:

+ Simplified provisioning
+ Preventing unauthorized changes
+ Reliable resource cleanup
+ Standardized templates
+ Enhancing existing processes

## Deployment stack resources

A deployment stack deploys - as the name promises - multiple resources (stack). These resources are definded in an ARM tempalte file (\*.json) or Bicep file(s) (\*.bicep). Within a deployment stack are pointers to all of the resources, resource groups, and management groups managed by the stack. The managed resources defined in the stack can easily be created, updated, or deleted with a single operation on the deployment stack resource. [^3]

## Deployment stack operations

Deployment stacks are part of the Microsoft.Resources resource provider and its full resource type is Microsoft.Resources/deploymentStacks. Its REST operations include creating a new stack, listing a stack, updating an existing stack, or deleting a stack. For its resources, you're able the view the resources in the stack, add and remove resources, and protect resources from deletion. [^3]

Options are:

+ Deny Settings
+ Detachment and deletion

### Deny Settings

The DenySettingsmode options

| Mode | Description |
| --- | --- |
| DenyDelete | ... allows resources managed by the stack to be modified, but not deleted. |
| DenyWriteAndDelete | ... makes the resources managed by the stack read-only. |
| None | ... allows resources managed by the stack to be modified and deleted. |

> [!Important]
> The deny settings supersede any Azure role-based access control (RBAC) permissions that may be in place.

### Detachment and deletion

A detached resource is a resource created by a deployment stack but no longer tracked and managed by it. The resources will be set to detached if you delete the deployment stack. By using the mandatory parameter `-ActionOnUnmanage` detachment and deletion will be controled. The setting is set at creating, updating or removing a deployment stack.

If a deployment stack will be removed, ...

| Mode | Description |
| --- | --- |
| DeleteAll | ... all resources will be deleted |
| DetachAll | ... no resources will be deleted |
| DeleteResources | ... all resources will be deleted but RGs and MGs |

## Examples woking with deployment stacks

### Introduction

For deployment stacks bicep and ARM templates are possible to be used. Also all scopes (mg, subscription, rg) are supported. In the following examples only resource groups are taken.

### Create

To test and create a DeploymentStack use:

```ps1
$params = @{
    ResourceGroupName = '<yourResourceGroupName>'
    Name = '<yourDeploymentName>'
    TemplateFile = '.\DeployStack01.bicep'
    saName = '<yourStorageAccountName>'
    ActionOnUnmanage = 'DeleteAll'
    DenySettingsMode = 'None'
}

Test-AzResourceGroupDeploymentStack @params

New-AzResourceGroupDeploymentStack @params
```

or

```ps1
az stack group validate --resource-group '<yourResourceGroupName>' `
                        --name '<yourDeploymentName>' `
                        --template-file .\DeployStack01.bicep `
                        --parameters saName='<yourStorageAccountName>' `
                        --action-on-unmanage deleteAll `
                        --deny-settings-mode none

az stack group create   --resource-group '<yourResourceGroupName>' `
                        --name '<yourDeploymentName>' `
                        --template-file .\DeployStack01.bicep `
                        --parameters saName='<yourStorageAccountName>' `
                        --action-on-unmanage deleteAll `
                        --deny-settings-mode none
```

### List

To get a list of deplyoment stacks of a resource group use the following commands:

```ps1
Get-AzResourceGroupDeploymentStack -ResourceGroupName '<yourResourceGroupName>'
```

or

```ps1
az stack group list --resource-group '<yourResourceGroupName>'
az stack group show --resource-group '<yourResourceGroupName>' --name '<yourStackName>'
```

### Update

In PowerShell use the cmdlet `Set-AzResourceGroupDeploymentStack` with the same parameters of creating a stack:

```ps1
$params = @{
    ResourceGroupName = '<yourResourceGroupName>'
    Name = '<yourDeploymentName>'
    TemplateFile = '.\DeployStack01.bicep'
    saName = '<yourStorageAccountName>'
    ActionOnUnmanage = 'DeleteAll'
    DenySettingsMode = 'None'
}

Set-AzResourceGroupDeploymentStack @params
```

Do you prefere to work with Azure CLI an update is the same as creating. So use `az stack group create` with the same parameters, maybe different values or bicep-file.

### Remove

```ps1
Remove-AzResourceGroupDeploymentStack -ResourceGroupName '<yourResourceGroupName>' `
                                      -Name '<yourStackName>' `
                                      -ActionOnUnmanage DeleteResources
```

or

```ps1
az stack group delete --name '<yourStackName>' `
                      --resource-group '<yourResourceGroupName>' `
                      --action-on-unmanage deleteResources
```

## Links

| Topic | Link |
| --- | --- |
| Learning Path | <https://learn.microsoft.com/en-us/training/modules/introduction-to-deployment-stacks/> |

[^1]: [Source](https://learn.microsoft.com/en-us/training/modules/introduction-to-deployment-stacks/2-what-deployment-stacks)
[^2]: [Source](https://learn.microsoft.com/en-us/training/modules/introduction-to-deployment-stacks/3-why-deployment-stacks)
[^3]: [Source](https://learn.microsoft.com/en-us/training/modules/introduction-to-deployment-stacks/4-deployment-stack-resource)
