function Get-TeamViewerDevice {
    [CmdletBinding(DefaultParameterSetName = "FilteredList")]
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(ParameterSetName = "ByDeviceId")]
        [ValidateScript( { $_ | Resolve-TeamViewerDeviceId } )]
        [Alias("DeviceId")]
        [string]
        $Id,

        [Parameter(ParameterSetName = "FilteredList")]
        [int]
        $TeamViewerId,

        [Parameter(ParameterSetName = "FilteredList")]
        [ValidateSet('Online', 'Busy', 'Away', 'Offline')]
        [string]
        $FilterOnlineState,

        [Parameter(ParameterSetName = "FilteredList")]
        [ValidateScript( { $_ | Resolve-TeamViewerGroupId } )]
        [Alias("GroupId")]
        [object]
        $Group
    )

    $resourceUri = "$(Get-TeamViewerApiUri)/devices";
    $parameters = @{ }

    switch ($PsCmdlet.ParameterSetName) {
        'ByDeviceId' {
            $resourceUri += "/$Id"
            $parameters = $null
        }
        'FilteredList' {
            if ($TeamViewerId) {
                $parameters['remotecontrol_id'] = "r$TeamViewerId"
            }
            if ($FilterOnlineState) {
                $parameters['online_state'] = $FilterOnlineState.ToLower()
            }
            if ($Group) {
                $groupId = $Group | Resolve-TeamViewerGroupId
                $parameters['groupid'] = $groupId
            }
        }
    }

    $response = Invoke-TeamViewerRestMethod `
        -ApiToken $ApiToken `
        -Uri $resourceUri `
        -Method Get `
        -Body $parameters `
        -WriteErrorTo $PSCmdlet `
        -ErrorAction Stop

    Write-Output ($response.devices | ConvertTo-TeamViewerDevice)
}
