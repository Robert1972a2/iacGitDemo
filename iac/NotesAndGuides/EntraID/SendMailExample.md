# Send Mail

Example for sending Mails ...

---

Table of Content

- [Send Mail](#send-mail)
  - [Requirements](#requirements)
  - [Send-MgUserMail](#send-mgusermail)
  - [Invoke-MgRestMethod](#invoke-mgrestmethod)

---

## Requirements

Modules:

- Microsoft.Graph.Users.Actions
- Microsoft.Graph.Authentication

Permissions:

User.Read.All
Mail.Send

## Send-MgUserMail

```PowerShell
$BodyParameter = @{
    Message = @{
        Subject = "DIST - Testing Microsoft Graph"
        Body = @{
            ContentType = "text"
            Content = "Hello world! - DIST"
        }
        ToRecipients = @(
            @{
                EmailAddress = @{
                    Address = "admin@trg.dist.at"
                }
            }
        )
    }
}
$Sender = Get-MgUser -Filter "UserPrincipalName eq 'sherlock@trg.dist.at'"
Send-MgUserMail -UserId $Sender.Id -BodyParameter $BodyParameter
```

## Invoke-MgRestMethod

```PowerShell
$Body = @"
{
  "Message": {
    "Body": {
      "Content": "Hello world! - DIST",
      "ContentType": "text"
    },
    "ToRecipients": [
      {
        "EmailAddress": {
          "Address": "admin@trg.dist.at"
        }
      }
    ],
    "Subject": "DIST - Testing Microsoft Graph"
  }
}
"@
$Sender = Get-MgUser -Filter "UserPrincipalName eq 'sherlock@trg.dist.at'"
$URI = "https://graph.microsoft.com/v1.0/users/{$($Sender.Id)}/sendMail"

 Invoke-MgRestMethod -Method POST -Body $Body -Uri $URI
```
