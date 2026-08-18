function Add-TeamViewerUserGroupMember {
    [CmdletBinding(SupportsShouldProcess = $true)]

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
        [object[]]
        [Alias('UserGroupMemberId')]
        [Alias('UserGroupMember')]
        [Alias('MemberId')]
        [Alias('UserId')]
        [Alias('User')]
        $Member
    )

    begin {
        $Id = $UserGroup | Resolve-TeamViewerUserGroupId
        $ResourceUri = "$(Get-TeamViewerApiUri)/usergroups/$Id/members"
        $MembersToAdd = @()
        $Body = @()
        $null = $ApiToken # https://github.com/PowerShell/PSScriptAnalyzer/issues/1472

        function Invoke-TeamViewerRestMethodInternal {
            $Result = Invoke-TeamViewerRestMethod `
                -ApiToken $ApiToken `
                -Uri $ResourceUri `
                -Method Post `
                -ContentType 'application/json; charset=utf-8' `
                -Body ([System.Text.Encoding]::UTF8.GetBytes(($Body))) `
                -WriteErrorTo $PSCmdlet `
                -ErrorAction Stop

            Write-Output ($Result | ConvertTo-TeamViewerUserGroupMember)
        }
    }

    process {
        # when members are provided as pipeline input, each member is provided as a separate statement,
        # thus the members should be combined into one array in order to send a single request.
        if ($PSCmdlet.ShouldProcess($Member, 'Add user groups member')) {
            if ($Member -notmatch 'u[0-9]+') {
                ForEach-Object {
                    $Member = [int[]]$Member
                }
            }
            else {
                ForEach-Object {
                    $Member = [int[]]$Member.trim('u')
                }
            }

            if ($Member -isnot [array]) {
                $MembersToAdd = @([UInt32]$Member)
            }
            else {
                $MembersToAdd += [UInt32[]]$Member
            }

            $Payload = $MembersToAdd -join ', '
            $Body = "[$Payload]"
        }

        # Web API accepts a maximum of 100 accounts. Thus we send a request and reset the `membersToAdd` in order to accept more members
        if ($MembersToAdd.Length -eq 100) {
            Invoke-TeamViewerRestMethodInternal
            $MembersToAdd = @()
        }
    }

    end {
        # A request needs to be sent if there were less than 100 members
        if ($MembersToAdd.Length -gt 0) {
            Invoke-TeamViewerRestMethodInternal
        }
    }
}
