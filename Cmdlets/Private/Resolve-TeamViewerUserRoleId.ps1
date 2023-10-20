
function Resolve-TeamViewerUserRoleId {
    param(
        [Parameter(ValueFromPipeline = $true, Mandatory = $true)]
        [Object]
        $UserRole
    )
    Process {
        if ($UserRole.PSObject.TypeNames -contains 'TeamViewerPS.UserRole') {
            return [string]$UserRole.RoleID
        }
        elseif ($UserRole -match '^[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}$') {
            return [string]$UserRole
        }
        else {
            throw "Invalid role group identifier '$UserRole'. Must be either a [TeamViewerPS.UserRole] or [UUID] "
        }
    }
}
