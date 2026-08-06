function Resolve-TeamViewerUserGroupId {
    param(
        [Parameter(ValueFromPipeline = $true, Mandatory = $true)]
        [object]
        $UserGroup
    )

    process {
        if ($UserGroup.PSObject.TypeNames -contains 'TeamViewerPS.UserGroup') {
            [UInt64]$UserGroup.Id
        }
        elseif ($UserGroup -is [string]) {
            [UInt64]$UserGroup
        }
        elseif ($UserGroup -is [UInt64] -or $UserGroup -is [Int64] -or $UserGroup -is [int]) {
            [UInt64]$UserGroup
        }
        else {
            throw "Invalid user group identifier '$UserGroup'. Must be either a [TeamViewerPS.UserGroup], [UInt64], [Int64] or [string]."
        }
    }
}
