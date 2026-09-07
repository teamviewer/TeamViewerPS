function Set-TeamViewerManager {
    [CmdletBinding(SupportsShouldProcess = $true, DefaultParameterSetName = 'Device_ByParameters')]

    [OutputType([void])]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $APIToken,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateScript( {
                if (($_.PSObject.TypeNames -contains 'TeamViewerPS.Manager') -and -not $_.Group_Id -and -not $_.Device_Id) {
                    $PSCmdlet.ThrowTerminatingError(
                        ('Invalid manager object. Manager must be a group or device manager.' | `
                            ConvertTo-ErrorRecord -ErrorCategory InvalidArgument))
                }
                $_ | Resolve-TeamViewerManagerId
            })]
        [Alias('ManagerId')]
        [Alias('Id')]
        [object]
        $Manager,

        [Parameter(ParameterSetName = 'Device_ByParameters')]
        [Parameter(ParameterSetName = 'Device_ByProperties')]
        [ValidateScript( { $_ | Resolve-TeamViewerManagedDeviceId } )]
        [Alias('DeviceId', 'ManagedDeviceId', 'ManagedDevice')]
        [object]
        $Device,

        [Parameter(ParameterSetName = 'Group_ByParameters')]
        [Parameter(ParameterSetName = 'Group_ByProperties')]
        [ValidateScript( { $_ | Resolve-TeamViewerManagedGroupId })]
        [Alias('GroupId', 'ManagedGroupId', 'ManagedGroup')]
        [object]
        $Group,

        [Parameter(ParameterSetName = 'Device_ByParameters')]
        [Parameter(ParameterSetName = 'Group_ByParameters')]
        [AllowEmptyCollection()]
        [string[]]
        $Permissions,

        [Parameter(Mandatory = $true, ParameterSetName = 'Device_ByProperties')]
        [Parameter(Mandatory = $true, ParameterSetName = 'Group_ByProperties')]
        [hashtable]
        $Property
    )

    begin {
        $null = $Property # https://github.com/PowerShell/PSScriptAnalyzer/issues/1472

        $Body = @{}

        switch -Wildcard ($PSCmdlet.ParameterSetName) {
            '*ByParameters' {
                $Body['permissions'] = @($Permissions)
            }
            '*ByProperties' {
                @('permissions') | Where-Object { $Property[$_] } | ForEach-Object { $Body[$_] = $Property[$_] }
            }
        }

        if ($Body.Count -eq 0) {
            $PSCmdlet.ThrowTerminatingError(
                ('The given input does not change the manager.' | ConvertTo-ErrorRecord -ErrorCategory InvalidArgument))
        }
    }
    process {
        $Device_Id = $null
        $Group_Id = $null

        if ($Manager.PSObject.TypeNames -contains 'TeamViewerPS.Manager') {
            if ($Device -or $Group) {
                $PSCmdlet.ThrowTerminatingError(
                    ('Device or Group parameter must not be specified if a [TeamViewerPS.Manager] object is given.' | ConvertTo-ErrorRecord -ErrorCategory InvalidArgument))
            }

            if ($Manager.Device_Id) {
                $Device_Id = $Manager.Device_Id
            }
            elseif ($Manager.Group_Id) {
                $Group_Id = $Manager.Group_Id
            }
        }
        elseif ($Device) {
            $Device_Id = $Device | Resolve-TeamViewerManagedDeviceId
        }
        elseif ($Group) {
            $Group_Id = $Group | Resolve-TeamViewerManagedGroupId
        }
        else {
            $PSCmdlet.ThrowTerminatingError(
                ('Device or Group parameter must be specified if no [TeamViewerPS.Manager] object is given.' | ConvertTo-ErrorRecord -ErrorCategory InvalidArgument))
        }

        $managerId = $Manager | Resolve-TeamViewerManagerId

        if ($Device_Id) {
            $Resource_Uri = "$(Get-TeamViewerAPIUri)/managed/devices/$Device_Id/managers/$managerId"
            $Process_Message = 'Update managed device manager'
        }
        elseif ($Group_Id) {
            $Resource_Uri = "$(Get-TeamViewerAPIUri)/managed/groups/$Group_Id/managers/$managerId"
            $Process_Message = 'Update managed group manager'
        }

        if ($PSCmdlet.ShouldProcess($managerId, $Process_Message)) {
            Invoke-TeamViewerRestMethod `
                -APIToken $APIToken `
                -Uri $Resource_Uri `
                -Method Put `
                -ContentType 'application/json; charset=utf-8' `
                -Body ([System.Text.Encoding]::UTF8.GetBytes(($Body | ConvertTo-Json))) `
                -WriteErrorTo $PSCmdlet | `
                Out-Null
        }
    }
}
