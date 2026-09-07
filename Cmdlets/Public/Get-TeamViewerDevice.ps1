function Get-TeamViewerDevice {
    [CmdletBinding(DefaultParameterSetName = 'List')]

    [OutputType('TeamViewerPS.Device')]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $APIToken,

        [Parameter(ParameterSetName = 'ByDeviceId')]
        [ValidateScript( { $_ | Resolve-TeamViewerDeviceId } )]
        [Alias('Id', 'DeviceId')]
        [string]
        $Device,

        [Parameter(ParameterSetName = 'List')]
        [ValidateRange(1, [int]::MaxValue)]
        [int]
        $TeamViewerId,

        [Parameter(ParameterSetName = 'List')]
        [ValidateSet('Online', 'Busy', 'Away', 'Offline')]
        [string]
        $FilterBy_OnlineState,

        [Parameter(ParameterSetName = 'List')]
        [ValidateScript( { $_ | Resolve-TeamViewerGroupId } )]
        [Alias('GroupId')]
        [object]
        $Group
    )

    $Resource_Uri = "$(Get-TeamViewerAPIUri)/devices"
    $Parameters = @{ }

    switch ($PsCmdlet.ParameterSetName) {
        'ByDeviceId' {
            $Resource_Uri += "/$Device"
            $Parameters = $null
        }
        'List' {
            if ($TeamViewerId) {
                $Parameters['remotecontrol_id'] = "r$TeamViewerId"
            }
            if ($FilterBy_OnlineState) {
                $Parameters['online_state'] = $FilterBy_OnlineState.ToLower()
            }
            if ($Group) {
                $GroupId = $Group | Resolve-TeamViewerGroupId
                $Parameters['groupid'] = $GroupId
            }
        }
    }

    $Response = Invoke-TeamViewerRestMethod `
        -APIToken $APIToken `
        -Uri $Resource_Uri `
        -Method Get `
        -Body $Parameters `
        -WriteErrorTo $PSCmdlet `
        -ErrorAction Stop

    Write-Output ($Response.devices | ConvertTo-TeamViewerDevice)
}
