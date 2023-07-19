function Resolve-TeamViewerUserGroupMemberMemberId {
    param(
        [Parameter(ValueFromPipeline = $true, Mandatory = $true)]
        [object]
        $UserGroupMember
    )
    Process {
        if ($UserGroupMember.PSObject.TypeNames -contains 'TeamViewerPS.UserGroupMember') {
            return $UserGroupMember.AccountId
        }
        elseif ($UserGroupMember -match 'u[0-9]+') {
            return $UserGroupMember
        }
        elseif ($UserGroupMember -is [int]) {
            return $UserGroupMember
        }
        else {
            throw "Invalid user group identifier '$UserGroupMember'. Must be either a [TeamViewerPS.UserGroupMember],[TeamViewerPS.User] or [int] ."
        }
    }
}
