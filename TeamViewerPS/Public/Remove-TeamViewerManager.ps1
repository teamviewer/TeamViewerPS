function Remove-TeamViewerManager {
    [CmdletBinding(SupportsShouldProcess = $true, DefaultParameterSetName = "ByDeviceId")]
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

        [Parameter(ParameterSetName = 'ByDeviceId')]
        [ValidateScript( { $_ | Resolve-TeamViewerManagedDeviceId } )]
        [Alias("DeviceId")]
        [object]
        $Device,

        [Parameter(ParameterSetName = 'ByGroupId')]
        [ValidateScript( { $_ | Resolve-TeamViewerManagedGroupId })]
        [Alias("GroupId")]
        [object]
        $Group
    )
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
            $processMessage = "Remove manager from managed device"
        }
        elseif ($groupId) {
            $resourceUri = "$(Get-TeamViewerApiUri)/managed/groups/$groupId/managers/$managerId"
            $processMessage = "Remove manager from managed group"
        }

        if ($PSCmdlet.ShouldProcess($managerId, $processMessage)) {
            Invoke-TeamViewerRestMethod `
                -ApiToken $ApiToken `
                -Uri $resourceUri `
                -Method Delete `
                -WriteErrorTo $PSCmdlet | `
                Out-Null
        }
    }
}
