$GREEN = "`e[32m"
$RESET = "`e[0m"
$ACCOUNT = 'root'
$WORKSPACE_ROOT = "/mnt/mmcblk0p1/eta-regulator-board" # /home/eta-regulator-board

$utcNow = Get-Date -Format "yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'fff'Z'" -AsUTC
$buildDateTimeMark = Get-Date -Format "yyyyMMdd-HHmmss"

$WEB_API_APP_NAME = "eta-regulator-board-web-api"
$WEB_UI_APP_NAME = "eta-regulator-board-web-ui"


function Sync-DateTime ([string] $ipaddr) {
    Write-Host "Sync date&time according to the device timezone (${utcNow})..." -ForegroundColor Green
    ssh ${ACCOUNT}@${ipaddr} "ntpd -q -p ptbtime1.ptb.de" # Network Time Protocol daemon
    Start-Sleep -Seconds 2
    Write-Host
}

function Initialize-AppFolders ([string]$ipaddr, [string[]] $AppRootFolders) {
    Write-Host "Initializing the app folders..." -ForegroundColor Green
    foreach ( $folder in $AppRootFolders) {
        ssh ${ACCOUNT}@${ipaddr} "mkdir -p ${WORKSPACE_ROOT}${folder}/"
    }

    Start-Sleep -Seconds 2
    Write-Host
}

function Find-ExternalError([System.Object]$remoteOutput) {
    [bool]$hasError = 0

    if ($null -eq $remoteOutput) {
        return $hasError
    }


    $remoteOutputArray = $null
    if ($remoteOutput -isnot [array]) {
        $remoteOutputArray = ($remoteOutput)
    }
    else {
        $remoteOutputArray = $remoteOutput
    }

    foreach ( $remoteOutputItem in $remoteOutputArray) {
        if ($remoteOutputItem.PSobject.Properties.Name.Contains('Exception') -eq 'False') {
            Write-Host "$($remoteOutputItem.Exception.Message) ($($remoteOutputItem.Exception.GetType().Name))" -BackgroundColor Red
            $hasError = 1
        }
        else {
            Write-Host $remoteOutputItem
        }
    }


    return $hasError
}