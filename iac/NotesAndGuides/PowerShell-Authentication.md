# Azure PowerShell - Authentication

This guide shows you the possibilities to authenticate with Azure PowerShell.

---

Table of Contents

+ [Interactive logon](#interactive-logon)
+ [Service principal logon](#service-principal-logon)
  + [Password/Secret](#passwordsecret)
  + [Certificate](#certificate)
  + [Managed Identity](#managed-identity)

---

## Interactive logon

To use the interactive mode of Azure PowerShell type the following command:

```powershell
Get-Help Connect-AzAccount

Connect-AzAccount
Connect-AzAccount -AccountId <yourUPN>
Connect-AzAccount -Tenant <yourTenantID>
```

To get to know which user is currently signed in:

```powershell
Get-AzContext
Get-AzContext | Select-Object Account, Subscription, Environment
```

Indicating the subscription is important if your User has permissions in multiple subscriptions:

```powershell
Connect-AzAccount -Subscription <yourSubscriptionID or name>
```

To change the subscription after sign in:

```powershell
Get-AzSubscription
Set-AzContext -Subscription <yourSubscriptionID or name>
```

To logout

```powershell
Disconnect-AzAccount
```

## Service principal logon

To sign in as SP use one of the following ways:

### Password/Secret

A password must be created for your SP in Entra ID. Keep in mind, that all passwords have an expiration date. Use the parameter `-ServicePrincipal` for a SP sign in and the parameters `-ApplicationId`, `-Credential` and `-TenantId`. The credential object must be created first:

```powershell
$credential = New-Object System.Management.Automation.PSCredential `
                -ArgumentList '<yourAppID>',(ConvertTo-SecureString '<yourAppPassword>' -AsPlainText -Force)

Connect-AzAccount -ServicePrincipal -Credential $credential -TenantId <yourTenantID>
```

For changing subscription or getting other information use the statements described in the [section above](#interactive-logon).

### Certificate

To sign in as SP but using a certificate, use the following:

```powershell
$cert = Get-ChildItem cert:\<LocationAndThumbprintOfyourCertificate>

Connect-AzAccount -ServicePrincipal `
                  -ApplicationId <yourAppID> `
                  -CertificateThumbprint $cert.Thumbprint `
                  -TenantId <yourTenantID>
```

A certificate must be created and the public key has to be uploaded to your Application registration. To prepare and upload the certificate.

### Managed Identity

On systems with a managed identity (e.g. VMs running in Azure or Azure Arc systems) sign in with the following command:

```powershell
Connect-AzAccount -Identity
```
