param(
    [string]$ipaddr,
    [string]$distro,
    [string]$root,
    [string]$checkConnection
)

Import-Module $PSScriptRoot\deployment_support.ps1 -Force


$WEB_UI_APP_NAME = "eta-regulator-board-web-ui"
$APP_ROOT = "/web-ui"

Write-Host "--------Deployment of '$WEB_UI_APP_NAME'--------"
Write-Host
# Check connection
if ($checkConnection -eq '$True') {
    CheckConnection -ipaddr $ipaddr
    Write-Host
    Start-Sleep -Seconds 2
}


# Sync date&time on OpenWrt OS
Sync-DateTime -ipaddr $ipaddr

# Shutting down UHTTPD
Write-Host "Shutting down UHTTPD web server with '$WEB_UI_APP_NAME'..."
$remoteOutput = ssh ${ACCOUNT}@${ipaddr} '/etc/init.d/uhttpd stop' *>&1
$hasError = Find-ExternalError -remoteOutput $remoteOutput
if ($hasError) {
    # exit
}
Start-Sleep -Seconds 2
Write-Host

# Initializing the app folders
Initialize-AppFolders -ipaddr $ipaddr -AppRootFolders $APP_ROOT

# Clear app forlder
Write-Host "Removing orignal files '$WEB_UI_APP_NAME'..."
$remoteOutput = ssh ${ACCOUNT}@${ipaddr} "rm -rf ${WORKSPACE_ROOT}${APP_ROOT}/" *>&1
$hasError = Find-ExternalError -remoteOutput $remoteOutput
if ($hasError) {
    Exit 1
}
Start-Sleep -Seconds 2
Write-Host



# Deleting JS and CSS maps files
Write-Host "Deleting JS and CSS source maps files..."
Get-ChildItem -Path "./${root}/distro/${distro}/build" -Recurse -Include "*.map" | Remove-Item -Force -Recurse
Start-Sleep -Seconds 2
Write-Host

# Copying files
Write-Host "Copying updated files..."
$remoteOutput = scp -r ${root}/distro/${distro}/build ${ACCOUNT}@${ipaddr}:${WORKSPACE_ROOT}${APP_ROOT} *>&1
$hasError = Find-ExternalError -remoteOutput $remoteOutput
if ($hasError) {
    Exit 1
}
Start-Sleep -Seconds 2
Write-Host

# Updating UHTTPD configuration
Write-Host "Updating UHTTPD configuration for '$WEB_UI_APP_NAME'..."
$remoteOutput = scp ${root}/configs/uhttpd ${ACCOUNT}@${ipaddr}:/etc/config/uhttpd *>&1
$hasError = Find-ExternalError -remoteOutput $remoteOutput
if ($hasError) {
    Exit 1
}
Start-Sleep -Seconds 2
Write-Host

Write-Host "Starting UHTTPD web server with '$WEB_UI_APP_NAME'..."
$remoteOutput = ssh ${ACCOUNT}@${IPADDR} '/etc/init.d/uhttpd start' *>&1
$hasError = Find-ExternalError -remoteOutput $remoteOutput
if ($hasError) {
    Write-Error $remoteOutput
    Exit 1
}
Write-Host "UHTTPD web server with '$WEB_UI_APP_NAME' was started!"
Start-Sleep -Seconds 2