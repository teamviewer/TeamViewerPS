function Get-TeamViewerManager {
    [CmdletBinding(DefaultParameterSetName = 'ByDeviceId')]

    [OutputType('TeamViewerPS.Manager')]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true, ParameterSetName = 'ByDeviceId')]
        [ValidateScript( { $_ | Resolve-TeamViewerManagedDeviceId } )]
        [Alias('DeviceId')]
        [object]
        $Device,

        [Parameter(Mandatory = $true, ParameterSetName = 'ByGroupId')]
        [ValidateScript( { $_ | Resolve-TeamViewerManagedGroupId } )]
        [Alias('GroupId')]
        [object]
        $Group
    )

    $ResourceUri = $null

    switch ($PsCmdlet.ParameterSetName) {
        'ByDeviceId' {
            $DeviceId = $Device | Resolve-TeamViewerManagedDeviceId
            $ResourceUri = "$(Get-TeamViewerApiUri)/managed/devices/$DeviceId/managers"
        }
        'ByGroupId' {
            $GroupId = $Group | Resolve-TeamViewerManagedGroupId
            $ResourceUri = "$(Get-TeamViewerApiUri)/managed/groups/$GroupId/managers"
        }
    }

    $Response = Invoke-TeamViewerRestMethod `
        -ApiToken $ApiToken `
        -Uri $ResourceUri `
        -Method Get `
        -WriteErrorTo $PSCmdlet `
        -ErrorAction Stop

    switch ($PsCmdlet.ParameterSetName) {
        'ByDeviceId' {
            Write-Output ($Response.resources | ConvertTo-TeamViewerManager -DeviceId $DeviceId )
        }
        'ByGroupId' {
            Write-Output ($Response.resources | ConvertTo-TeamViewerManager -GroupId $GroupId)
        }
    }
}
