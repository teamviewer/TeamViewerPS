function Add-TeamViewerUserGroupMember {
    [CmdletBinding(SupportsShouldProcess = $true)]

    [OutputType('TeamViewerPS.UserGroupMember')]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $APIToken,

        [Parameter(Mandatory = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerUserGroupId } )]
        [Alias('Id', 'UserGroupId')]
        [object]
        $UserGroup,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [object[]]
        [Alias('UserId', 'UserIds')]
        $User
    )

    begin {
        $UserGroup_Id = $UserGroup | Resolve-TeamViewerUserGroupId

        $Resource_Uri = "$(Get-TeamViewerAPIUri)/usergroups/$UserGroup_Id/members"
        $Members_ToAdd = @()
        $Body = @()
        $null = $APIToken # https://github.com/PowerShell/PSScriptAnalyzer/issues/1472

        function Invoke-TeamViewerRestMethodInternal {
            $Result = Invoke-TeamViewerRestMethod `
                -APIToken $APIToken `
                -Uri $Resource_Uri `
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
        if ($PSCmdlet.ShouldProcess($User, 'Add user(s) to user group')) {
            if ($User -notmatch 'u[0-9]+') {
                ForEach-Object {
                    $User = [int[]]$User
                }
            }
            else {
                ForEach-Object {
                    $User = [int[]]$User.trim('u')
                }
            }

            if ($User -isnot [array]) {
                $Members_ToAdd = @([UInt32]$User)
            }
            else {
                $Members_ToAdd += [UInt32[]]$User
            }

            $Payload = $Members_ToAdd -join ', '
            $Body = "[$Payload]"
        }

        # Web API accepts a maximum of 100 accounts. Thus we send a request and reset the `membersToAdd` in order to accept more members
        if ($Members_ToAdd.Length -eq 100) {
            Invoke-TeamViewerRestMethodInternal
            $Members_ToAdd = @()
        }
    }

    end {
        # A request needs to be sent if there were less than 100 members
        if ($Members_ToAdd.Length -gt 0) {
            Invoke-TeamViewerRestMethodInternal
        }
    }
}
