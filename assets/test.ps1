param(
    [string]$source_location=''
)


$IPADDR = "omega-8f79"
$ACCOUNT = 'root'
$WORKSPACE_ROOT = "/mnt/mmcblk0p1/eta-regulator-board"

$APP_ROOT = "/web-api"
if ($source_location -ne '')
{
    scp -r ${source_location} ${ACCOUNT}@${IPADDR}:${WORKSPACE_ROOT}${APP_ROOT}
}
