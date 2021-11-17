function Resolve-TeamViewerUserGroupId {
    param(
        [Parameter(ValueFromPipeline = $true, Mandatory = $true)]
        [object]
        $UserGroup
    )
    Process {
        if ($UserGroup.PSObject.TypeNames -contains 'TeamViewerPS.UserGroup') {
            return [ulong]$UserGroup.Id
        }
        elseif ($UserGroup -is [string]) {
            return [ulong]$UserGroup
        }
        elseif ($UserGroup -is [ulong] -or $UserGroup -is [long] -or $UserGroup -is [int]) {
            return [ulong]$UserGroup
        }
        else {
            throw "Invalid user group identifier '$UserGroup'. Must be either a [TeamViewerPS.UserGroup], [ulong], [long] or [string]."
        }
    }
}
