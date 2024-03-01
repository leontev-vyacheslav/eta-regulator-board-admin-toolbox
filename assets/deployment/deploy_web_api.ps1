param(
    [string]$ipaddr,
    [string]$distro,
    [string]$root
)

Import-Module $PSScriptRoot\deployment_support.ps1 -Force


$WEB_API_APP_NAME = "eta-regulator-board-web-api"
$APP_ROOT = "/web-api"


# Check connection
CheckConnection -ipaddr $ipaddr
Write-Host
Start-Sleep -Seconds 2

# Sync date&time on OpenWrt OS
Sync-DateTime -ipaddr $ipaddr


# Shutting down 'eta-regulator-board-web-api' and removing orignal files...
Write-Host "Shutting down '$WEB_API_APP_NAME'..."
$remoteOutput = ssh ${ACCOUNT}@${ipaddr} "cd ${WORKSPACE_ROOT}${APP_ROOT}/src;kill `$(cat PID_FILE)" *>&1
$hasError = Find-ExternalError -remoteOutput $remoteOutput
if ($hasError) {
    # exit
}

# Removing orignal files...
Write-Host "Removing orignal files '$WEB_API_APP_NAME'..."
$remoteOutput = ssh ${ACCOUNT}@${ipaddr} "rm -rf ${WORKSPACE_ROOT}${APP_ROOT}/src/" *>&1
$hasError = Find-ExternalError -remoteOutput $remoteOutput
if ($hasError) {
    exit
}
Start-Sleep -Seconds 2
Write-Host


# Deleting compiled Python version dependent modules...
Write-Host "Deleting compiled Python version dependent modules..."
Get-ChildItem -Path "./${root}/distributable/${distro}/build/src" -Recurse -Include "__pycache__" | Remove-Item -Force -Recurse
Start-Sleep -Seconds 2
Write-Host


# Copying updated files...
Write-Host "Copying updated files..." -ForegroundColor Green
$build = "${root}/distributable/${distro}/build"
$remoteOutput = scp -r ${build}/src ${build}/data ${build}/log ${build}/startup.sh ${build}/requirements.txt ${ACCOUNT}@${ipaddr}:${WORKSPACE_ROOT}${APP_ROOT} *>&1
$hasError = Find-ExternalError -remoteOutput $remoteOutput
if ($hasError) {
    exit
}

Start-Sleep -Seconds 2
Write-Host


# Adding the ability to startup the application after OS reboot...
Write-Host "Adding the ability to startup '$WEB_API_APP_NAME' after OS reboot..."
$remoteOutput = scp ${root}/configs/rc.local ${ACCOUNT}@${ipaddr}:/etc/rc.local  *>&1
$hasError = Find-ExternalError -remoteOutput $remoteOutput
if ($hasError) {
    exit
}

$remoteOutput = ssh ${ACCOUNT}@${ipaddr} 'chmod 755 /etc/rc.local' *>&1
$hasError = Find-ExternalError -remoteOutput $remoteOutput
if ($hasError) {
    exit
}

$remoteOutput = ssh ${ACCOUNT}@${ipaddr} "echo -e '# ${WEB_API_APP_NAME} date&time build mark ${buildDateTimeMark}' >> /etc/rc.local" *>&1
$hasError = Find-ExternalError -remoteOutput $remoteOutput
if ($hasError) {
    exit
}

Start-Sleep -Seconds 2
Write-Host

# Launching 'eta-regulator-board-web-api...
Write-Host "Launching '$WEB_API_APP_NAME'..."
ssh ${ACCOUNT}@${ipaddr} "cd ${WORKSPACE_ROOT}${APP_ROOT}/; sh startup.sh"