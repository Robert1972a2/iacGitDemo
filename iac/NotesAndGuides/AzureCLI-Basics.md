# Azure CLI Basics

In this guide you can read how to use Azure CLI for Azure resource management.

---

Table of Contents

+ [Installation/Upgrade of Azure CLI](#installationupgrade-of-azure-cli)
  + [Installation](#installation)
  + [Upgrade](#upgrade)
+ [Usage of Azure CLI](#usage-of-azure-cli)
  + [Subgroups \& commands](#subgroups--commands)
  + [Version](#version)
  + [Help](#help)
  + [Formatting Output](#formatting-output)
  + [Filtering Output](#filtering-output)
+ [Beyond this guide](#beyond-this-guide)

---

## Installation/Upgrade of Azure CLI

### Installation

To install Azure CLI in Windows you could use `winget.exe`.

```shell
winget.exe search AzureCLI
winget.exe show --id Microsoft.AzureCLI
winget.exe install --id Microsoft.AzureCLI
```

For macOS use [brew](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-macos?view=azure-cli-latest) and for Linux use the recommended tool described in [documentation](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-linux?view=azure-cli-latest&pivots=apt).

### Upgrade

Under Windows use `winget.exe` or the Azure CLI tool itself:

```shell
winget.exe upgrade --id Microsoft.AzureCLI

az upgrade
```

A benefit of using `az upgrade` is that all extension could be updated too. Check the [documentation](https://learn.microsoft.com/en-us/cli/azure/update-azure-cli?view=azure-cli-latest) to find more possibilites to control the upgrade process.

## Usage of Azure CLI

Read about some important ways to use Azure CLI.

### Subgroups & commands

Azure CLI allows you to work with specific resources in Azure via *Subgroups* and via *Commands* you are able to perform an action on resources. E.g. to get a list of all virtual machines use:

```shell
az vm list
az vm list --show-details
```

| group | `az` |
| subgroup | `vm` |
| command | `list` |
| parameter | `--show-details` |

Note, a subgroup could have further subgroups. To see subgroups and commands use the parameter `--help`.

```shell
az network list
az network --help
```

### Version

To get the current version of Azure CLI type the one of the following command:

```shell
az --version
az -v
```

You see, parameters for Azure CLI are indicated by two '-' with long parameter name(s) or one '-' with the short parameter name (in most cases it's a single character).

### Help

To get help use the parameter `--help` or `-h`:

```shell
az --help
az -h
```

### Formatting Output

 be To format the output of an Azure CLI command use the parameter `--output` or `-o`. Possible values are

+ JSON (default),
+ table
+ tsv (tab-seperated values)
+ yaml
+ jsonc (JSON with comments)

```shell
# JSON (default)
az vm list --output json

# Table (human-readable columns)
az vm list --output table

# TSV (tab-separated values, good for parsing)
az vm list --output tsv

# YAML
az vm list --output yaml

# JSONC (JSON with comments)
az vm list --output jsonc
```

Azure CLI uses *JMESPath query language* to format and filter the output. The JMESPath statement is passed into with the paramter `--query`. This allows you to control, which property should appear in the output.

If the output of the command consists of **a single JSON object**, use the following command for a single property:

```shell
az account show
az account show --query "name"
```

For multiple properties use fielname for output followed by a `:` and the property name, use the `,` as seperator and enclose it with `{ NameInOutput:PropertyName, NameInOutput:PropertyName, ... }`:

```shell
az account show
az account show --query "{Name:name, State:state}"
```

> :exclamation: Note: Property names are case sensitive.

If the output of a command is **a list of JSON objects** you have to take it into accout. Use `[].` at the beginning of your query statement. For just a single property in the output use:

```shell
# Extract only the name of your resource groups
az group list --query "[].name"
```

As soon you would like to name your output or to multiple properties in the output, you have to use `{}`:

```shell
# Extract only the name of your resource groups
az group list --query "[].{RGName:name}"

# Extract the name and the of your resource groups
az group list --query "[].{RGName:name, Location:location}"
```

Of course, you could combine the parameter `--query` and `--output` or `-o`.

```shell
az group list --query "[].{RGName:name, Location:location} -o table"
```

### Filtering Output

The parameter `--query` is also used for filtering the output. Put your condition between the `[]`. The common notation is `[?property operator ValueToCompare]`.

```shell
# All resource groups in the location austriaeast
 az group list --query "[?location=='austriaeast']" -o table
```

Possible operators

+ Equality operators

    | Operator | |  
    | --- | --- |
    | `==` | equals |
    | `!=` | not equals |

+ Relational operators

    | Operator | |
    | --- | --- |
    | `<` | less than |
    | `<=` | less than or equal |
    | `>` | greater than |
    | `>=` | greater than or equal |

+ Logical operators

    | Operator | |
    | --- | --- |
    | `&&` | AND |
    | `\|\|` | OR |
    | `!` | NOT |

+ String operators

    | Operator | |
    | --- | --- |
    | starts_with(property, StringToFind) | string starts with |
    | ends_with(property, StringToFind) | string ends with |
    | contains(property, StringToFind) | string contains |
    | matches(property, StringToFind) | regex match |

Some examples:

```shell
# All running VMs
az vm list --show-details --query "[?powerState=='VM running']" -o table

# All VMs starting with 'pj1-' in the name
az vm list --query "[?starts_with(name, 'pj1-')]" -o table

# All running VMs starting with 'pj1-' in the name
az vm list --show-details --query "[?starts_with(name, 'pj1-') && powerState=='VM running']" -o table
```

Some more examples:

```shell
# VMs with 4 or more vCPUs
az vm list --query "[?hardwareProfile.vmSize >= 'Standard_D4s_v3']" -o table

# Not running VMs
az vm list --show-details --query "[?powerState != 'VM running']" -o table

# VMs in specific region AND running
az vm list --show-details --query "[?location == 'eastus' && powerState == 'VM running']" -o table
```

## Beyond this guide

In addition to the topics descibed in this guide, Azure CLI is offering e. g. an interactive mode, installing extension and much more. Have fun to explore this :smirk:
