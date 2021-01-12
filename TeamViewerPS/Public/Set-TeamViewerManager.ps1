function Set-TeamViewerManager {
    [CmdletBinding(SupportsShouldProcess = $true, DefaultParameterSetName = 'Device_ByParameters')]
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateScript( {
                if (($_.PSObject.TypeNames -contains 'TeamViewerPS.Manager') -And -Not $_.GroupId -And -Not $_.DeviceId) {
                    $PSCmdlet.ThrowTerminatingError(
                        ("Invalid manager object. Manager must be a group or device manager." | `
                                ConvertTo-ErrorRecord -ErrorCategory InvalidArgument))
                }
                $_ | Resolve-TeamViewerManagerId
            })]
        [Alias("ManagerId")]
        [Alias("Id")]
        [object]
        $Manager,

        [Parameter(ParameterSetName = 'Device_ByParameters')]
        [Parameter(ParameterSetName = 'Device_ByProperties')]
        [ValidateScript( { $_ | Resolve-TeamViewerManagedDeviceId } )]
        [Alias("DeviceId")]
        [object]
        $Device,

        [Parameter(ParameterSetName = 'Group_ByParameters')]
        [Parameter(ParameterSetName = 'Group_ByProperties')]
        [ValidateScript( { $_ | Resolve-TeamViewerManagedGroupId })]
        [Alias("GroupId")]
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
    Begin {
        # Warning suppresion doesn't seem to work.
        # See https://github.com/PowerShell/PSScriptAnalyzer/issues/1472
        $null = $Property

        $body = @{}
        switch -Wildcard ($PSCmdlet.ParameterSetName) {
            '*ByParameters' {
                $body['permissions'] = @($Permissions)
            }
            '*ByProperties' {
                @('permissions') | `
                    Where-Object { $Property[$_] } | `
                    ForEach-Object { $body[$_] = $Property[$_] }
            }
        }

        if ($body.Count -eq 0) {
            $PSCmdlet.ThrowTerminatingError(
                ("The given input does not change the manager." | `
                        ConvertTo-ErrorRecord -ErrorCategory InvalidArgument))
        }
    }
    Process {
        $deviceId = $null
        $groupId = $null
        if ($Manager.PSObject.TypeNames -contains 'TeamViewerPS.Manager') {
            if ($Device -Or $Group) {
                $PSCmdlet.ThrowTerminatingError(
                    ("Device or Group parameter must not be specified if a [TeamViewerPS.Manager] object is given." | `
                            ConvertTo-ErrorRecord -ErrorCategory InvalidArgument))
            }
            if ($Manager.DeviceId) {
                $deviceId = $Manager.DeviceId
            }
            elseif ($Manager.GroupId) {
                $groupId = $Manager.GroupId
            }
        }
        elseif ($Device) {
            $deviceId = $Device | Resolve-TeamViewerManagedDeviceId
        }
        elseif ($Group) {
            $groupId = $Group | Resolve-TeamViewerManagedGroupId
        }
        else {
            $PSCmdlet.ThrowTerminatingError(
                ("Device or Group parameter must be specified if no [TeamViewerPS.Manager] object is given." | `
                        ConvertTo-ErrorRecord -ErrorCategory InvalidArgument))
        }

        $managerId = $Manager | Resolve-TeamViewerManagerId
        if ($deviceId) {
            $resourceUri = "$(Get-TeamViewerApiUri)/managed/devices/$deviceId/managers/$managerId"
            $processMessage = "Update managed device manager"
        }
        elseif ($groupId) {
            $resourceUri = "$(Get-TeamViewerApiUri)/managed/groups/$groupId/managers/$managerId"
            $processMessage = "Update managed group manager"
        }

        if ($PSCmdlet.ShouldProcess($managerId, $processMessage)) {
            Invoke-TeamViewerRestMethod `
                -ApiToken $ApiToken `
                -Uri $resourceUri `
                -Method Put `
                -ContentType "application/json; charset=utf-8" `
                -Body ([System.Text.Encoding]::UTF8.GetBytes(($body | ConvertTo-Json))) `
                -WriteErrorTo $PSCmdlet | `
                Out-Null
        }
    }
}
