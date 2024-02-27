param(
    [string]$ipaddr
)

Import-Module $PSScriptRoot\deployment_support.ps1 -Force

Clear-Host

Write-Host "==========================================================="
Write-Host "Check connection with device ${ipaddr} in progress..."
Write-Host
# Check connection
$testConnectionStatus = Test-Connection -TargetName $ipaddr -IPv4 -Count 5
If($testConnectionStatus.Status -ne "Success")
{
    Write-Host "ERROR! Failed to connect to the device ${ipaddr}."
    Exit 1
} else {
    Write-Host "Successful connection to the device ${ipaddr}."
}
Write-Host "==========================================================="