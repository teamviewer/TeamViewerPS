function Remove-TeamViewerUserGroupMember {
    [CmdletBinding(SupportsShouldProcess = $true, DefaultParameterSetName = 'ByUserGroupMemberId')]

    [OutputType('TeamViewerPS.UserGroupMember')]

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
        [ValidateScript( { $_ | Resolve-TeamViewerUserGroupMemberId } )]
        [Alias('UserGroupMemberId')]
        [Alias('MemberId')]
        [Alias('UserId')]
        [Alias('User')]
        [object[]]
        $UserGroupMember
    )

    begin {
        $Id = $UserGroup | Resolve-TeamViewerUserGroupId
        $ResourceUri = "$(Get-TeamViewerApiUri)/usergroups/$Id/members"
        $MembersToRemove = @()
        $null = $ApiToken # https://github.com/PowerShell/PSScriptAnalyzer/issues/1472
        $null = $UserGroupMember

        function Invoke-TeamViewerRestMethodInternal {
            Invoke-TeamViewerRestMethod `
                -ApiToken $ApiToken `
                -Uri $ResourceUri `
                -Method Delete `
                -ContentType 'application/json; charset=utf-8' `
                -Body ([System.Text.Encoding]::UTF8.GetBytes(($Body))) `
                -WriteErrorTo $PSCmdlet `
                -ErrorAction Stop | `
                Out-Null
        }

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
        # when members are provided as pipeline input, each member is provided as separate statement,
        # thus the members should  be combined to one array in order to send a single request
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

        # Web API accepts max 100 accounts. Thus we send a request, and reset the `membersToRemove` in order to accept more members
        if ($MembersToRemove.Length -eq 100) {
            Invoke-TeamViewerRestMethodInternal
            $MembersToRemove = @()
        }
    }

    end {
        # A request needs to be send if there were less than 100 members
        if ($MembersToRemove.Length -gt 0) {
            Invoke-TeamViewerRestMethodInternal
        }
    }
}
