function Remove-TeamViewerManager {
    [CmdletBinding(SupportsShouldProcess = $true, DefaultParameterSetName = 'ByDeviceId')]

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

        [Parameter(ParameterSetName = 'ByDeviceId')]
        [ValidateScript( { $_ | Resolve-TeamViewerManagedDeviceId } )]
        [Alias('DeviceId')]
        [object]
        $Device,

        [Parameter(ParameterSetName = 'ByGroupId')]
        [ValidateScript( { $_ | Resolve-TeamViewerManagedGroupId })]
        [Alias('GroupId')]
        [object]
        $Group
    )

    process {
        $DeviceId = $null
        $GroupId = $null

        if ($Manager.PSObject.TypeNames -contains 'TeamViewerPS.Manager') {
            if ($Device -or $Group) {
                $PSCmdlet.ThrowTerminatingError(
                    ('Device or Group parameter must not be specified if a [TeamViewerPS.Manager] object is given.' | `
                        ConvertTo-ErrorRecord -ErrorCategory InvalidArgument))
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
                ('Device or Group parameter must be specified if no [TeamViewerPS.Manager] object is given.' | `
                    ConvertTo-ErrorRecord -ErrorCategory InvalidArgument))
        }

        $managerId = $Manager | Resolve-TeamViewerManagerId

        if ($DeviceId) {
            $ResourceUri = "$(Get-TeamViewerApiUri)/managed/devices/$DeviceId/managers/$managerId"
            $Process_Message = 'Remove manager from managed device'
        }
        elseif ($GroupId) {
            $ResourceUri = "$(Get-TeamViewerApiUri)/managed/groups/$GroupId/managers/$managerId"
            $Process_Message = 'Remove manager from managed group'
        }

        if ($PSCmdlet.ShouldProcess($managerId, $Process_Message)) {
            Invoke-TeamViewerRestMethod -ApiToken $ApiToken -Uri $ResourceUri -Method Delete -WriteErrorTo $PSCmdlet | Out-Null
        }
    }
}
