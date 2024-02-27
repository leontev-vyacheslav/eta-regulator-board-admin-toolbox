$GREEN = "`e[32m"
$RESET = "`e[0m"
$ACCOUNT = 'root'
$WORKSPACE_ROOT = "/mnt/mmcblk0p1/eta-regulator-board" # /home/eta-regulator-board

$utcNow = Get-Date -Format "yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'fff'Z'" -AsUTC
$buildDateTimeMark = Get-Date -Format "yyyyMMdd-HHmmss"

$WEB_API_APP_NAME = "eta-regulator-board-web-api"
$WEB_UI_APP_NAME = "eta-regulator-board-web-ui"