function Remove-TeamViewerUserGroupMember {
    [CmdletBinding(SupportsShouldProcess = $true, DefaultParameterSetName = 'ByUserGroupMemberId')]
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerUserGroupId } )]
        [Alias('UserGroupId')]
        [Alias('Id')]
        [object]
        $UserGroup,


        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerUserGroupMemberMemberId } )]
        [Alias('UserGroupMemberId')]
        [Alias('MemberId')]
        [Alias('UserId')]
        [Alias('User')]
        [object[]]
        $UserGroupMember
    )

    Begin {
        $id = $UserGroup | Resolve-TeamViewerUserGroupId
        $resourceUri = "$(Get-TeamViewerApiUri)/usergroups/$id/members"
        $membersToRemove = @()
        $null = $ApiToken # https://github.com/PowerShell/PSScriptAnalyzer/issues/1472
        $null = $UserGroupMember
        function Invoke-TeamViewerRestMethodInternal {
            Invoke-TeamViewerRestMethod `
                -ApiToken $ApiToken `
                -Uri $resourceUri `
                -Method Delete `
                -ContentType 'application/json; charset=utf-8' `
                -Body ([System.Text.Encoding]::UTF8.GetBytes(($body))) `
                -WriteErrorTo $PSCmdlet `
                -ErrorAction Stop | `
                Out-Null
        }

        function Get-MemberId {
            switch ($UserGroupMember) {
                { $UserGroupMember[0].PSObject.TypeNames -contains 'TeamViewerPS.UserGroupMember' } {
                    $UserGroupMember = $UserGroupMember | Resolve-TeamViewerUserGroupMemberMemberId
                    return $UserGroupMember
                }
                Default {
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

    Process {
        # when members are provided as pipeline input, each member is provided as separate statement,
        # thus the members should  be combined to one array in order to send a single request
        if ($PSCmdlet.ShouldProcess((Get-MemberId), 'Remove user group member')) {
            if (Get-MemberId -isnot [array]) {
                $membersToRemove += @(Get-MemberId)
            }
            else {
                $membersToRemove += Get-MemberId
            }
            $payload = $membersToRemove -join ', '
            $body = "[$payload]"
        }

        # WebAPI accepts max 100 accounts. Thus we send a request, and reset the `membersToRemove`
        # in order to accept more members
        if ($membersToRemove.Length -eq 100) {
            Invoke-TeamViewerRestMethodInternal
            $membersToRemove = @()
        }
    }

    End {
        # A request needs to be send if there were less than 100 members
        if ($membersToRemove.Length -gt 0) {
            Invoke-TeamViewerRestMethodInternal
        }
    }
}
