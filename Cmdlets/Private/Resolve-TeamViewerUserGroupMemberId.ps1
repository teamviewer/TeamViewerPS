function Resolve-TeamViewerUserGroupMemberMemberId {
    param(
        [Parameter(ValueFromPipeline = $true, Mandatory = $true)]
        [object]
        $UserGroupMember
    )

    process {
        if ($UserGroupMember.PSObject.TypeNames -contains 'TeamViewerPS.UserGroupMember') {
            $UserGroupMember.AccountId
        }
        elseif ($UserGroupMember -match 'u[0-9]+') {
            $UserGroupMember
        }
        elseif ($UserGroupMember -is [string]) {
            [int]$UserGroupMember
        }
        elseif ($UserGroupMember -is [int]) {
            $UserGroupMember
        }
        else {
            throw "Invalid user group identifier '$UserGroupMember'. Must be either a [TeamViewerPS.UserGroupMember],[TeamViewerPS.User] or [int] ."
        }
    }
}
