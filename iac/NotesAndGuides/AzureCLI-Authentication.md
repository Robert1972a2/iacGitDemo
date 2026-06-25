# Azure CLI - Authentication

This guide shows you the possibilities to authenticate with Azrue CLI.

---

Table of Contents

+ [Interactive logon](#interactive-logon)
+ [Service principal logon](#service-principal-logon)
  + [Password/Secret](#passwordsecret)
  + [Certificate](#certificate)
  + [Managed Identity](#managed-identity)

---

## Interactive logon

To use the interactive mode of Azure CLI type the following command:

```shell
az login --help

az login
az login --username joe@domain.com # prompt for password
az login --tenant <yourTenantID>
```

To get to know which user is currently signed in:

```shell
az account show
az account show --query "{UserName:user.name,SubscriptionName:name,State:state}"
```

Indicating the subscription is important if your User hase permissions in multiple subscriptions:

```shell
az login --subscription <yourSubscriptionID or name>
```

To change the subscription after sign in:

```shell
az account list
az account set --name <yourSubscriptionID or name>
```

To logout

```shell
az logout
```

## Service principal logon

To sign in as SP use on of the following ways:

### Password/Secret

A password must be created for your SP in Entra ID. Keep in mind, that all passwords have an expiration date. Use the parameter `--service-principal` for a SP sign in and the parameters `--username`, `--password` and `--tenant`:

```shell
az login --service-principal --username <yourAppID> --password <yourAppPassword> --tenant <yourTenantID>
```

For changing subscription or getting other information use the statements described in the [section above](#interactive-logon).

### Certificate

To sign in as SP but using a certificate, use the following:

```shell
az login --service-principal --username <yourAppID> --certificate /path/to/cert.pem --tenant <yourTenantID>
```

A certificate must be created and the public key has to be uploaded to your Application registration. To prepare the *.pem file use the following steps:

```PowerShell
Install-PSResource ConvertTo-PEM

$cert = Get-Childitem cert:\<LocationAndThumbprintOfyourCertificate>

$part1 = ConvertTo-PEM -Certificate $cert -PrivateKey
$part2 = ConvertTo-PEM -certificate $cert

$part1 + $part2 | Out-File -FilePath $Home\.Azure\<yourFileName>.pem
```

### Managed Identity

On system with a managed identity (e.g. VMs running Azure or Azure Arc systems) sign in with the following command:

```shell
az login --identity
```
