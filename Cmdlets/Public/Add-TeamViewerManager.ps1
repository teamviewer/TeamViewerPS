function Add-TeamViewerManager {
    [CmdletBinding(SupportsShouldProcess = $true, DefaultParameterSetName = 'DeviceByAccount')]

    [OutputType([void])]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $APIToken,

        [Parameter(Mandatory = $true, ParameterSetName = 'DeviceByAccount')]
        [Parameter(Mandatory = $true, ParameterSetName = 'GroupByAccount')]
        [string]
        $AccountId,

        [Parameter(Mandatory = $true, ParameterSetName = 'DeviceByManager')]
        [Parameter(Mandatory = $true, ParameterSetName = 'GroupByManager')]
        [ValidateScript( { $_ | Resolve-TeamViewerManagerId } )]
        [Alias('ManagerId')]
        [object]
        $Manager,

        [Parameter(Mandatory = $true, ParameterSetName = 'DeviceByUser')]
        [Parameter(Mandatory = $true, ParameterSetName = 'GroupByUser')]
        [ValidateScript( { $_ | Resolve-TeamViewerUserId } )]
        [object]
        $User,

        [Parameter(Mandatory = $true, ParameterSetName = 'GroupByUserGroup')]
        [Parameter(Mandatory = $true, ParameterSetName = 'DeviceByUserGroup')]
        [ValidateScript( { $_ | Resolve-TeamViewerUserGroupId })]
        [Alias('UserGroupId')]
        [object]
        $UserGroup,

        [Parameter(Mandatory = $true, ParameterSetName = 'GroupByAccount')]
        [Parameter(Mandatory = $true, ParameterSetName = 'GroupByManager')]
        [Parameter(Mandatory = $true, ParameterSetName = 'GroupByUser')]
        [Parameter(Mandatory = $true, ParameterSetName = 'GroupByUserGroup')]
        [ValidateScript( { $_ | Resolve-TeamViewerManagedGroupId } )]
        [Alias('GroupId', 'ManagedGroupId', 'ManagedGroup')]
        [object]
        $Group,

        [Parameter(Mandatory = $true, ParameterSetName = 'DeviceByAccount')]
        [Parameter(Mandatory = $true, ParameterSetName = 'DeviceByManager')]
        [Parameter(Mandatory = $true, ParameterSetName = 'DeviceByUser')]
        [Parameter(Mandatory = $true, ParameterSetName = 'DeviceByUserGroup')]
        [ValidateScript( { $_ | Resolve-TeamViewerManagedDeviceId } )]
        [Alias('DeviceId', 'ManagedDeviceId', 'ManagedDevice')]
        [object]
        $Device,

        [Parameter()]
        [AllowEmptyCollection()]
        [string[]]
        $Permissions
    )

    $Resource_Uri = $null

    switch -Wildcard ($PSCmdlet.ParameterSetName) {
        'Device*' {
            $DeviceId = $Device | Resolve-TeamViewerManagedDeviceId
            $Resource_Uri = "$(Get-TeamViewerAPIUri)/managed/devices/$DeviceId/managers"
            $Process_Message = 'Add manager to managed device'
        }
        'Group*' {
            $GroupId = $Group | Resolve-TeamViewerManagedGroupId
            $Resource_Uri = "$(Get-TeamViewerAPIUri)/managed/groups/$GroupId/managers"
            $Process_Message = 'Add manager to managed group'
        }
    }

    $Body = @{}

    switch -Wildcard ($PSCmdlet.ParameterSetName) {
        '*ByAccount' {
            $Body['accountId'] = $AccountId.TrimStart('u')
        }
        '*ByManager' {
            $Body['id'] = ($Manager | Resolve-TeamViewerManagerId).ToString()
        }
        '*ByUser' {
            $Body['accountId'] = ( $User | Resolve-TeamViewerUserId ).TrimStart('u')
        }
        '*ByUserGroup' {
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
            -APIToken $APIToken `
            -Uri $Resource_Uri `
            -Method Post `
            -ContentType 'application/json; charset=utf-8' `
            -Body ([System.Text.Encoding]::UTF8.GetBytes((ConvertTo-Json -InputObject @($Body)))) `
            -WriteErrorTo $PSCmdlet | Out-Null
    }
}
