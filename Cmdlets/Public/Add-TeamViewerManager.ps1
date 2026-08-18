function Add-TeamViewerManager {
    [CmdletBinding(SupportsShouldProcess = $true, DefaultParameterSetName = 'Device_ByAccountId')]

    [OutputType([void])]

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
        [Alias('ManagerId')]
        [object]
        $Manager,

        [Parameter(Mandatory = $true, ParameterSetName = 'Device_ByUserObject')]
        [Parameter(Mandatory = $true, ParameterSetName = 'Group_ByUserObject')]
        [ValidateScript( { $_ | Resolve-TeamViewerUserId } )]
        [object]
        $User,

        [Parameter(Mandatory = $true, ParameterSetName = 'Group_ByUserGroupId')]
        [Parameter(Mandatory = $true, ParameterSetName = 'Device_ByUserGroupId')]
        [ValidateScript( { $_ | Resolve-TeamViewerUserGroupId })]
        [Alias('UserGroupId')]
        [object]
        $UserGroup,

        [Parameter(Mandatory = $true, ParameterSetName = 'Group_ByAccountId')]
        [Parameter(Mandatory = $true, ParameterSetName = 'Group_ByManagerId')]
        [Parameter(Mandatory = $true, ParameterSetName = 'Group_ByUserObject')]
        [Parameter(Mandatory = $true, ParameterSetName = 'Group_ByUserGroupId')]
        [ValidateScript( { $_ | Resolve-TeamViewerManagedGroupId } )]
        [Alias('GroupId')]
        [object]
        $Group,

        [Parameter(Mandatory = $true, ParameterSetName = 'Device_ByAccountId')]
        [Parameter(Mandatory = $true, ParameterSetName = 'Device_ByManagerId')]
        [Parameter(Mandatory = $true, ParameterSetName = 'Device_ByUserObject')]
        [Parameter(Mandatory = $true, ParameterSetName = 'Device_ByUserGroupId')]
        [ValidateScript( { $_ | Resolve-TeamViewerManagedDeviceId } )]
        [Alias('DeviceId')]
        [object]
        $Device,

        [Parameter()]
        [AllowEmptyCollection()]
        [string[]]
        $Permissions
    )

    $ResourceUri = $null

    switch -Wildcard ($PSCmdlet.ParameterSetName) {
        'Device*' {
            $DeviceId = $Device | Resolve-TeamViewerManagedDeviceId
            $ResourceUri = "$(Get-TeamViewerApiUri)/managed/devices/$DeviceId/managers"
            $Process_Message = 'Add manager to managed device'
        }
        'Group*' {
            $GroupId = $Group | Resolve-TeamViewerManagedGroupId
            $ResourceUri = "$(Get-TeamViewerApiUri)/managed/groups/$GroupId/managers"
            $Process_Message = 'Add manager to managed group'
        }
    }

    $Body = @{}

    switch -Wildcard ($PSCmdlet.ParameterSetName) {
        '*ByAccountId' {
            $Body['accountId'] = $AccountId.TrimStart('u')
        }
        '*ByManagerId' {
            $Body['id'] = ($Manager | Resolve-TeamViewerManagerId).ToString()
        }
        '*ByUserObject' {
            $Body['accountId'] = ( $User | Resolve-TeamViewerUserId ).TrimStart('u')
        }
        '*ByUserGroupId' {
            $Body['usergroupId'] = $UserGroup | Resolve-TeamViewerUserGroupId
        }
    }

    if ($Permissions) {
        $Body['permissions'] = @($Permissions)
    }
    else {
        $Body['permissions'] = @()
    }

    if ($PSCmdlet.ShouldProcess($managerId, $Process_Message)) {
        Invoke-TeamViewerRestMethod `
            -ApiToken $ApiToken `
            -Uri $ResourceUri `
            -Method Post `
            -ContentType 'application/json; charset=utf-8' `
            -Body ([System.Text.Encoding]::UTF8.GetBytes((ConvertTo-Json -InputObject @($Body)))) `
            -WriteErrorTo $PSCmdlet | Out-Null
    }
}
