function Set-TeamViewerManager {
    [CmdletBinding(SupportsShouldProcess = $true, DefaultParameterSetName = 'Device_ByParameters')]

    [OutputType([void])]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

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
        [Alias('DeviceId')]
        [object]
        $Device,

        [Parameter(ParameterSetName = 'Group_ByParameters')]
        [Parameter(ParameterSetName = 'Group_ByProperties')]
        [ValidateScript( { $_ | Resolve-TeamViewerManagedGroupId })]
        [Alias('GroupId')]
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
        # Warning suppression doesn't seem to work.
        # See https://github.com/PowerShell/PSScriptAnalyzer/issues/1472
        $null = $Property

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
        $DeviceId = $null
        $GroupId = $null

        if ($Manager.PSObject.TypeNames -contains 'TeamViewerPS.Manager') {
            if ($Device -or $Group) {
                $PSCmdlet.ThrowTerminatingError(
                    ('Device or Group parameter must not be specified if a [TeamViewerPS.Manager] object is given.' | ConvertTo-ErrorRecord -ErrorCategory InvalidArgument))
            }

            if ($Manager.Device_Id) {
                $DeviceId = $Manager.Device_Id
            }
            elseif ($Manager.Group_Id) {
                $GroupId = $Manager.Group_Id
            }
        }
        elseif ($Device) {
            $DeviceId = $Device | Resolve-TeamViewerManagedDeviceId
        }
        elseif ($Group) {
            $GroupId = $Group | Resolve-TeamViewerManagedGroupId
        }
        else {
            $PSCmdlet.ThrowTerminatingError(
                ('Device or Group parameter must be specified if no [TeamViewerPS.Manager] object is given.' | ConvertTo-ErrorRecord -ErrorCategory InvalidArgument))
        }

        $managerId = $Manager | Resolve-TeamViewerManagerId

        if ($DeviceId) {
            $ResourceUri = "$(Get-TeamViewerApiUri)/managed/devices/$DeviceId/managers/$managerId"
            $Process_Message = 'Update managed device manager'
        }
        elseif ($GroupId) {
            $ResourceUri = "$(Get-TeamViewerApiUri)/managed/groups/$GroupId/managers/$managerId"
            $Process_Message = 'Update managed group manager'
        }

        if ($PSCmdlet.ShouldProcess($managerId, $Process_Message)) {
            Invoke-TeamViewerRestMethod `
                -ApiToken $ApiToken `
                -Uri $ResourceUri `
                -Method Put `
                -ContentType 'application/json; charset=utf-8' `
                -Body ([System.Text.Encoding]::UTF8.GetBytes(($Body | ConvertTo-Json))) `
                -WriteErrorTo $PSCmdlet | `
                Out-Null
        }
    }
}
