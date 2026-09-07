function Get-TeamViewerMemberByRole {
    [CmdletBinding()]

    [OutputType('TeamViewerPS.RoleMember')]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $APIToken,

        [Parameter(Mandatory = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerRoleId } )]
        [Alias('Id', 'RoleId')]
        [object]
        $Role
    )

    begin {
        $Role_Id = $Role | Resolve-TeamViewerRoleId

        function Out-RoleMember {
            param(
                [object]$Member_Id,
                [string]$Member_Type,
                [string]$Membership_Type,
                [object]$Via_UserGroupId
            )

            $Properties = [ordered]@{
                RoleId          = $Role_Id
                MemberType      = $Member_Type
                MemberId        = $Member_Id
                MembershipType  = $Membership_Type
                Via_UserGroupId = $Via_UserGroupId
            }

            $Result = New-Object -TypeName PSObject -Property $Properties
            $Result.PSObject.TypeNames.Insert(0, 'TeamViewerPS.RoleMember')

            Write-Output $Result
        }
    }

    process {
        $Users_Direct = Get-TeamViewerUserByRole -APIToken $APIToken -Role $Role_Id

        foreach ($User in $Users_Direct) {
            Out-RoleMember -Member_Id $User.UserId -Member_Type 'User' -Membership_Type 'Direct' -Via_UserGroupId $null
        }

        $Groups_Direct = Get-TeamViewerUserGroupByRole -APIToken $APIToken -Role $Role_Id

        foreach ($Group in $Groups_Direct) {
            $UserGroupId = $Group.UserGroupId

            Out-RoleMember -Member_Id $UserGroupId -Member_Type 'UserGroup' -Membership_Type 'Direct' -Via_UserGroupId $null

            $UserGroup_Members = Get-TeamViewerUserGroupMember -APIToken $APIToken -UserGroup $UserGroupId

            foreach ($UserGroup_Member in $UserGroup_Members) {
                Out-RoleMember -Member_Id $UserGroup_Member.Id -Member_Type 'User' -Membership_Type 'Indirect' -Via_UserGroupId $UserGroupId
            }
        }
    }
}
