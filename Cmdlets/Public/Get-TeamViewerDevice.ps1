function Get-TeamViewerDevice {
    [CmdletBinding(DefaultParameterSetName = 'FilteredList')]

    [OutputType('TeamViewerPS.Device')]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(ParameterSetName = 'ByDeviceId')]
        [ValidateScript( { $_ | Resolve-TeamViewerDeviceId } )]
        [Alias('DeviceId')]
        [string]
        $Id,

        [Parameter(ParameterSetName = 'FilteredList')]
        [ValidateRange(1, [int]::MaxValue)]
        [int]
        $TeamViewerId,

        [Parameter(ParameterSetName = 'FilteredList')]
        [ValidateSet('Online', 'Busy', 'Away', 'Offline')]
        [string]
        $FilterOnlineState,

        [Parameter(ParameterSetName = 'FilteredList')]
        [ValidateScript( { $_ | Resolve-TeamViewerGroupId } )]
        [Alias('GroupId')]
        [object]
        $Group
    )

    $ResourceUri = "$(Get-TeamViewerApiUri)/devices"
    $Parameters = @{ }

    switch ($PsCmdlet.ParameterSetName) {
        'ByDeviceId' {
            $ResourceUri += "/$Id"
            $Parameters = $null
        }
        'FilteredList' {
            if ($TeamViewerId) {
                $Parameters['remotecontrol_id'] = "r$TeamViewerId"
            }
            if ($FilterOnlineState) {
                $Parameters['online_state'] = $FilterOnlineState.ToLower()
            }
            if ($Group) {
                $GroupId = $Group | Resolve-TeamViewerGroupId
                $Parameters['groupid'] = $GroupId
            }
        }
    }

    $Response = Invoke-TeamViewerRestMethod `
        -ApiToken $ApiToken `
        -Uri $ResourceUri `
        -Method Get `
        -Body $Parameters `
        -WriteErrorTo $PSCmdlet `
        -ErrorAction Stop

    Write-Output ($Response.devices | ConvertTo-TeamViewerDevice)
}
