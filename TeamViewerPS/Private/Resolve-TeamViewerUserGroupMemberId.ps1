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
        elseif ($UserGroupMember -is [string]) {
            return [int]$UserGroupMember
        }
        elseif ($UserGroupMember -is [int]) {
            return $UserGroupMember
        }
        else {
            throw "Invalid user group identifier '$UserGroupMember'. Must be either a [TeamViewerPS.UserGroupMember], [ulong], [long] or [string]."
        }
    }
}
