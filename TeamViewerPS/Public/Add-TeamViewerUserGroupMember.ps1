function Add-TeamViewerUserGroupMember {
    [CmdletBinding(SupportsShouldProcess = $true)]
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
        $Member
    )

    Begin {

        $id = $UserGroup | Resolve-TeamViewerUserGroupId
        $resourceUri = "$(Get-TeamViewerApiUri)/usergroups/$id/members"
        $body = @()
        $null = $ApiToken # https://github.com/PowerShell/PSScriptAnalyzer/issues/1472

        function Invoke-TeamViewerRestMethodInternal {
            $result = Invoke-TeamViewerRestMethod `
                -ApiToken $ApiToken `
                -Uri $resourceUri `
                -Method Post `
                -ContentType 'application/json; charset=utf-8' `
                -Body ([System.Text.Encoding]::UTF8.GetBytes(($body))) `
                -WriteErrorTo $PSCmdlet `
                -ErrorAction Stop

            Write-Output ($result | ConvertTo-TeamViewerUserGroupMember)
        }
    }

    Process {
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
                $membersToAdd = @([UInt32]$Member)
            }
            else {
                $membersToAdd += [UInt32[]]$Member
            }
            $payload = $membersToAdd -join ', '
            $body = "[$payload]"
        }

        # WebAPI accepts a maximum of 100 accounts. Thus we send a request and reset the `membersToAdd`
        # in order to accept more members
        if ($membersToAdd.Length -eq 100) {
            Invoke-TeamViewerRestMethodInternal
            $membersToAdd = @()
        }
    }

    End {
        # A request needs to be sent if there were less than 100 members
        if ($membersToAdd.Length -gt 0) {
            Invoke-TeamViewerRestMethodInternal
        }
    }
}
