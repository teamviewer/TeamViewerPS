function Add-TeamViewerUserGroupMember {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerUserGroupId } )]
        [Alias("UserGroupId")]
        [Alias("Id")]
        [object]
        $UserGroup,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [int[]]
        $Member
    )

    Begin {
        $id = $UserGroup | Resolve-TeamViewerUserGroupId
        $resourceUri = "$(Get-TeamViewerApiUri)/usergroups/$id/members"
        $membersToAdd = @()
        $null = $ApiToken # https://github.com/PowerShell/PSScriptAnalyzer/issues/1472

        function Invoke-TeamViewerRestMethodInternal {
            $result = Invoke-TeamViewerRestMethod `
                -ApiToken $ApiToken `
                -Uri $resourceUri `
                -Method Post `
                -ContentType "application/json; charset=utf-8" `
                -Body ([System.Text.Encoding]::UTF8.GetBytes(($membersToAdd | ConvertTo-Json))) `
                -WriteErrorTo $PSCmdlet `
                -ErrorAction Stop
            Write-Output ($result | ConvertTo-TeamViewerUserGroupMember)
        }
    }

    Process {
        # when members are provided as pipline input, each meber is provided as separate statment,
        # thus the members should  be combined to one array, otherwise we will send several request
        if ($PSCmdlet.ShouldProcess($Member, "Add user groups member")) {
            $membersToAdd += $Member
        }

        # WebAPI accepts max 100 accounts. Thus we send a request, and reset the `membersToAdd`
        # in order to accept more mebers
        if ($membersToAdd.Length -eq 100) {
            Invoke-TeamViewerRestMethodInternal
            $membersToAdd = @()
        }
    }

    End {
        # A request needs to be send if there were less than 100 members
        if ($membersToAdd.Length -gt 0) {
            Invoke-TeamViewerRestMethodInternal
        }
    }
}
