function Remove-TeamViewerUserGroupMember {
    [CmdletBinding(SupportsShouldProcess = $true)]

    [OutputType('TeamViewerPS.UserGroupMember')]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $APIToken,

        [Parameter(Mandatory = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerUserGroupId } )]
        [Alias('UserGroupId')]
        [Alias('Id')]
        [object]
        $UserGroup,


        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerUserGroupMemberId } )]
        [Alias('UserGroupMemberId')]
        [Alias('MemberId')]
        [Alias('UserId')]
        [Alias('User')]
        [Alias('UserGroupMemberIds', 'MemberIds', 'UserIds')]
        [object[]]
        $UserGroupMember
    )

    begin {
        $Id = $UserGroup | Resolve-TeamViewerUserGroupId
        $Resource_Uri = "$(Get-TeamViewerAPIUri)/usergroups/$Id/members"
        $MembersToRemove = @()
        $null = $APIToken # https://github.com/PowerShell/PSScriptAnalyzer/issues/1472
        $null = $UserGroupMember

        function Get-MemberId {
            switch ($UserGroupMember) {
                { $UserGroupMember[0].PSObject.TypeNames -contains 'TeamViewerPS.UserGroupMember' } {
                    $UserGroupMember = $UserGroupMember | Resolve-TeamViewerUserGroupMemberId
                    return $UserGroupMember
                }
                default {
                    if ($UserGroupMember -notmatch 'u[0-9]+') {
                        ForEach-Object {
                            $UserGroupMember = [int[]]$UserGroupMember
                        }
                    }
                    else {
                        ForEach-Object {
                            $UserGroupMember = [int[]]$UserGroupMember.trim('u')
                        }
                    }
                    return $UserGroupMember
                }
            }
        }
    }

    process {
        # When members are provided as pipeline input, each member is provided as a separate statement,
        # so they must be combined into one array to send a single request.
        if ($PSCmdlet.ShouldProcess((Get-MemberId), 'Remove user group member')) {
            if (Get-MemberId -isnot [array]) {
                $MembersToRemove += @(Get-MemberId)
            }
            else {
                $MembersToRemove += Get-MemberId
            }

            $Payload = $MembersToRemove -join ', '
            $Body = "[$Payload]"
        }

        # The web API accepts a maximum of 100 accounts, so we send a request and reset `membersToRemove` to accept more members.
        if ($MembersToRemove.Length -eq 100) {
            Invoke-TeamViewerJsonRestMethod `
                -APIToken $APIToken `
                -Uri $Resource_Uri `
                -Method Delete `
                -Body $Body `
                -CallerCmdlet $PSCmdlet | Out-Null
            $MembersToRemove = @()
        }
    }

    end {
        # Send a request if there are fewer than 100 members.
        if ($MembersToRemove.Length -gt 0) {
            Invoke-TeamViewerJsonRestMethod `
                -APIToken $APIToken `
                -Uri $Resource_Uri `
                -Method Delete `
                -Body $Body `
                -CallerCmdlet $PSCmdlet | Out-Null
        }
    }
}
