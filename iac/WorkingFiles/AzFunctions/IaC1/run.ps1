using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

$Begin = @(
    "Unsere Cloud-Architektur ermöglicht es uns,",
    "In unserem aktuellen Azure-Projekt versuchen wir,",
    "Die neue IaC-Strategie erlaubt es dem Team,",
    "Durch unser innovatives Governance-Modell wollen wir,",
    "Mit unserem skalierbaren Deployment-Ansatz planen wir,",
    "Dank unserer Zero-Touch-Automatisierung hoffen wir,",
    "Durch die Einführung von Bicep-Modulen beabsichtigen wir,",
    "Mit unserer Multi-Tenant-Plattform möchten wir,",
    "Durch unser Self-Healing-Framework erwarten wir,",
    "Mit unserem GitOps-basierten Betriebsmodell versuchen wir,"
)

$Middle = @(
    "sämtliche Ressourcen dynamisch zu provisionieren,",
    "komplexe Abhängigkeiten automatisch aufzulösen,",
    "alle Compliance-Vorgaben in Echtzeit zu validieren,",
    "die gesamte Infrastruktur ohne menschliches Zutun zu verwalten,",
    "unsere Deployments vollständig zu entkoppeln,",
    "sämtliche Workloads in ein einziges Template zu pressen,",
    "alle Policies zentral zu erzwingen,",
    "unser Monitoring auf ein neues Chaos-Level zu heben,",
    "die Kostenexplosion elegant zu verschleiern,",
    "unser Logging endgültig unlesbar zu machen,"
)

$End = @(
    "um maximale Business-Agilität vorzutäuschen.",
    "damit niemand mehr versteht, wie das System funktioniert.",
    "um sicherzustellen, dass wir trotzdem manuell eingreifen müssen.",
    "damit unsere Architekturdiagramme noch verwirrender werden.",
    "um die Cloud-Reife unseres Unternehmens künstlich aufzublasen.",
    "damit wir später behaupten können, es sei 'Best Practice'.",
    "um die Verantwortung elegant an die Plattform abzuschieben.",
    "damit wir im nächsten Meeting wichtig klingen.",
    "um sicherzustellen, dass alles wie ein PoC aussieht, aber produktiv läuft.",
    "damit wir weiterhin so tun können, als wäre alles automatisiert."
)

# Write to the Azure Functions log stream.
Write-Host "PowerShell HTTP trigger function processed a request."

$body = "" 
$begin = Get-Random -InputObject $Begin
$middle = Get-Random -InputObject $Middle
$end = Get-Random -InputObject $End
$body = "$begin $middle $end"

$body += "`n"

$body += "Generated at: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')`n"
$body += $PSversionTable.PSVersion.ToString() + "`n"
    
# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
        StatusCode = [HttpStatusCode]::OK
        Body       = $body
    })
