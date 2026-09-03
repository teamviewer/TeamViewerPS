function Get-TeamViewerManager {
    [CmdletBinding(DefaultParameterSetName = 'ByDevice')]

    [OutputType('TeamViewerPS.Manager')]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true, ParameterSetName = 'ByDevice')]
        [ValidateScript( { $_ | Resolve-TeamViewerManagedDeviceId } )]
        [Alias('Id', 'DeviceId', 'ManagedDeviceId', 'ManagedDevice')]
        [object]
        $Device,

        [Parameter(Mandatory = $true, ParameterSetName = 'ByGroup')]
        [ValidateScript( { $_ | Resolve-TeamViewerManagedGroupId } )]
        [Alias('GroupId', 'ManagedGroupId', 'ManagedGroup')]
        [object]
        $Group
    )

    $ResourceUri = $null

    switch ($PsCmdlet.ParameterSetName) {
        'ByDevice' {
            $DeviceId = $Device | Resolve-TeamViewerManagedDeviceId
            $ResourceUri = "$(Get-TeamViewerApiUri)/managed/devices/$DeviceId/managers"
        }
        'ByGroup' {
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
        'ByDevice' {
            Write-Output ($Response.resources | ConvertTo-TeamViewerManager -DeviceId $DeviceId )
        }
        'ByGroup' {
            Write-Output ($Response.resources | ConvertTo-TeamViewerManager -GroupId $GroupId)
        }
    }
}
