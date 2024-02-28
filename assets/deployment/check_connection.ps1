param(
    [string]$ipaddr
)

Import-Module $PSScriptRoot\deployment_support.ps1 -Force

CheckConnection -ipaddr $ipaddr
