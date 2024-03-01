param(
    [string]$ipaddr,
    [string]$distro,
    [string]$root
)

Import-Module $PSScriptRoot\deployment_support.ps1 -Force


$WEB_API_APP_NAME = "eta-regulator-board-web-api"
$APP_ROOT = "/web-api"


# Check connection
Write-Host "Check connection with device ${ipaddr} in progress..."
$testConnectionStatus = Test-Connection -TargetName $ipaddr -IPv4 -Count 5
If ($testConnectionStatus.Status -ne "Success") {
    Write-Host "ERROR! Failed to connect to the device ${ipaddr}."
    Exit 1
}
Write-Host "Connection with the device ${ipaddr} was established!"
Write-Host
Start-Sleep -Seconds 2

# Sync date&time on OpenWrt OS
Sync-DateTime -ipaddr $ipaddr


# Shutting down 'eta-regulator-board-web-api' and removing orignal files...
Write-Host "Shutting down '$WEB_API_APP_NAME'..."
# ssh ${ACCOUNT}@${IPADDR} "wget --post-data='security_pass=onioneer' --tries=2 ${WEB_API_SHUTDOWN_ENDPOINT}"
$remoteOutput = ssh ${ACCOUNT}@${IPADDR} "cd ${WORKSPACE_ROOT}${APP_ROOT}/src;kill `$(cat PID_FILE)" *>&1
$hasError = Find-ExternalError -remoteOutput $remoteOutput
if ($hasError) {
    # exit
}

# Removing orignal files...
Write-Host "Removing orignal files '$WEB_API_APP_NAME'..."
$remoteOutput = ssh ${ACCOUNT}@${IPADDR} "rm -rf ${WORKSPACE_ROOT}${APP_ROOT}/src/" *>&1
$hasError = Find-ExternalError -remoteOutput $remoteOutput
if ($hasError) {
    exit
}
Start-Sleep -Seconds 2
Write-Host


# Deleting compiled Python version dependent modules...
Write-Host "Deleting compiled Python version dependent modules..."  -ForegroundColor Green
Get-ChildItem -Path "./src" -Recurse -Include "__pycache__" | Remove-Item -Force -Recurse
Start-Sleep -Seconds 2
Write-Host


# Copying updated files...
Write-Host "Copying updated files..." -ForegroundColor Green

$remoteOutput = scp -r src data log ./startup.sh ./requirements.txt ${ACCOUNT}@${IPADDR}:${WORKSPACE_ROOT}${APP_ROOT} *>&1
$hasError = Find-ExternalError -remoteOutput $remoteOutput
if ($hasError) {
    exit
}

Start-Sleep -Seconds 2
Write-Host


# Adding the ability to startup the application after OS reboot...
Write-Host "Adding the ability to startup '$WEB_API_APP_NAME' after OS reboot..." -ForegroundColor Green
$remoteOutput = scp ../.deployment/configs/rc.local ${ACCOUNT}@${IPADDR}:/etc/rc.local  *>&1
$hasError = Find-ExternalError -remoteOutput $remoteOutput
if ($hasError) {
    exit
}

$remoteOutput = ssh ${ACCOUNT}@${IPADDR} 'chmod 755 /etc/rc.local' *>&1
$hasError = Find-ExternalError -remoteOutput $remoteOutput
if ($hasError) {
    exit
}

$remoteOutput = ssh ${ACCOUNT}@${IPADDR} "echo -e '# ${WEB_API_APP_NAME} date&time build mark ${buildDateTimeMark}' >> /etc/rc.local" *>&1
$hasError = Find-ExternalError -remoteOutput $remoteOutput
if ($hasError) {
    exit
}

Start-Sleep -Seconds 2
Write-Host

# Launching 'eta-regulator-board-web-api...
Write-Host "Launching '$WEB_API_APP_NAME'..." -ForegroundColor Green
ssh ${ACCOUNT}@${IPADDR} "cd ${WORKSPACE_ROOT}${APP_ROOT}/; sh startup.sh"