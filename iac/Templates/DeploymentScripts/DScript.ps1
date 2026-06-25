
param (
    [parameter(Mandatory = $true)]    
    [string]$VMName,

    [parameter(Mandatory = $true)]
    [string]$RGName
)

# Connect-AzAccount -Identity

$VM = Get-AzVM -Name $VMName -ResourceGroupName $RGName -Status

if ($VM.statuses.code -contains 'PowerState/running') {
    Stop-AzVM -Name $VMName -ResourceGroupName $RGName -Force
    Write-Output "The VM $VMName was stopped."
}
else {
    Write-Output "The VM $VMName was NOT stopped."
}