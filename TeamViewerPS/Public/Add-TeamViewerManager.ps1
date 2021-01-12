function Add-TeamViewerManager {
    [CmdletBinding(SupportsShouldProcess = $true, DefaultParameterSetName = 'Device_ByAccountId')]
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true, ParameterSetName = 'Device_ByAccountId')]
        [Parameter(Mandatory = $true, ParameterSetName = 'Group_ByAccountId')]
        [string]
        $AccountId,

        [Parameter(Mandatory = $true, ParameterSetName = 'Device_ByManagerId')]
        [Parameter(Mandatory = $true, ParameterSetName = 'Group_ByManagerId')]
        [ValidateScript( { $_ | Resolve-TeamViewerManagerId } )]
        [Alias("ManagerId")]
        [object]
        $Manager,

        [Parameter(Mandatory = $true, ParameterSetName = 'Device_ByUserObject')]
        [Parameter(Mandatory = $true, ParameterSetName = 'Group_ByUserObject')]
        [ValidateScript( { $_ | Resolve-TeamViewerUserId } )]
        [object]
        $User,

        [Parameter(Mandatory = $true, ParameterSetName = 'Group_ByAccountId')]
        [Parameter(Mandatory = $true, ParameterSetName = 'Group_ByManagerId')]
        [Parameter(Mandatory = $true, ParameterSetName = 'Group_ByUserObject')]
        [ValidateScript( { $_ | Resolve-TeamViewerManagedGroupId } )]
        [Alias("GroupId")]
        [object]
        $Group,

        [Parameter(Mandatory = $true, ParameterSetName = 'Device_ByAccountId')]
        [Parameter(Mandatory = $true, ParameterSetName = 'Device_ByManagerId')]
        [Parameter(Mandatory = $true, ParameterSetName = 'Device_ByUserObject')]
        [ValidateScript( { $_ | Resolve-TeamViewerManagedDeviceId } )]
        [Alias("DeviceId")]
        [object]
        $Device,

        [Parameter()]
        [AllowEmptyCollection()]
        [string[]]
        $Permissions
    )

    $resourceUri = $null
    switch -Wildcard ($PSCmdlet.ParameterSetName) {
        'Device*' {
            $deviceId = $Device | Resolve-TeamViewerManagedDeviceId
            $resourceUri = "$(Get-TeamViewerApiUri)/managed/devices/$deviceId/managers"
            $processMessage = "Add manager to managed device"
        }
        'Group*' {
            $groupId = $Group | Resolve-TeamViewerManagedGroupId
            $resourceUri = "$(Get-TeamViewerApiUri)/managed/groups/$groupId/managers"
            $processMessage = "Add manager to managed group"
        }
    }

    $body = @{}
    switch -Wildcard ($PSCmdlet.ParameterSetName) {
        '*ByAccountId' {
            $body["accountId"] = $AccountId.TrimStart('u')
        }
        '*ByManagerId' {
            $body["id"] = $Manager | Resolve-TeamViewerManagerId
        }
        '*ByUserObject' {
            $body["accountId"] = $User.Id.TrimStart('u')
        }
    }

    if ($Permissions) {
        $body["permissions"] = @($Permissions)
    }
    else {
        $body["permissions"] = @()
    }

    if ($PSCmdlet.ShouldProcess($managerId, $processMessage)) {
        Invoke-TeamViewerRestMethod `
            -ApiToken $ApiToken `
            -Uri $resourceUri `
            -Method Post `
            -ContentType "application/json; charset=utf-8" `
            -Body ([System.Text.Encoding]::UTF8.GetBytes((@($body) | ConvertTo-Json -AsArray))) `
            -WriteErrorTo $PSCmdlet | `
            Out-Null
    }
}
