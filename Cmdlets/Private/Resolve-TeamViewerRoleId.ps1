
function Resolve-TeamViewerRoleId {
    param(
        [Parameter(ValueFromPipeline = $true, Mandatory = $true)]
        [object]
        $Role
    )

    process {
        if ($Role.PSObject.TypeNames -contains 'TeamViewerPS.Role') {
            Write-Output ([string]$Role.RoleID)
        }
        elseif ($Role -match '^[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}$') {
            Write-Output ([string]$Role)
        }
        else {
            throw "Invalid role identifier '$Role'. Must be either a [TeamViewerPS.Role] or [UUID] "
        }
    }
}
