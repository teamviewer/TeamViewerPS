function Resolve-TeamViewerUserGroupMemberId {
    param(
        [Parameter(ValueFromPipeline = $true, Mandatory = $true)]
        [object]
        $UserGroupMember
    )

    process {
        if ($UserGroupMember.PSObject.TypeNames -contains 'TeamViewerPS.UserGroupMember') {
            Write-Output $UserGroupMember.Id
        }
        elseif ($UserGroupMember -match 'u[0-9]+') {
            Write-Output $UserGroupMember
        }
        elseif ($UserGroupMember -is [string]) {
            Write-Output ([int]$UserGroupMember)
        }
        elseif ($UserGroupMember -is [int]) {
            Write-Output $UserGroupMember
        }
        else {
            throw "Invalid user group identifier '$UserGroupMember'. Must be either a [TeamViewerPS.UserGroupMember],[TeamViewerPS.User] or [int] ."
        }
    }
}
