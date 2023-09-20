function Get-TeamViewerManager {
    [CmdletBinding(DefaultParameterSetName = "ByDeviceId")]
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true, ParameterSetName = "ByDeviceId")]
        [ValidateScript( { $_ | Resolve-TeamViewerManagedDeviceId } )]
        [Alias("DeviceId")]
        [object]
        $Device,

        [Parameter(Mandatory = $true, ParameterSetName = "ByGroupId")]
        [ValidateScript( { $_ | Resolve-TeamViewerManagedGroupId } )]
        [Alias("GroupId")]
        [object]
        $Group
    )

    $resourceUri = $null
    switch ($PsCmdlet.ParameterSetName) {
        'ByDeviceId' {
            $deviceId = $Device | Resolve-TeamViewerManagedDeviceId
            $resourceUri = "$(Get-TeamViewerApiUri)/managed/devices/$deviceId/managers"
        }
        'ByGroupId' {
            $groupId = $Group | Resolve-TeamViewerManagedGroupId
            $resourceUri = "$(Get-TeamViewerApiUri)/managed/groups/$groupId/managers"
        }
    }

    $response = Invoke-TeamViewerRestMethod `
        -ApiToken $ApiToken `
        -Uri $resourceUri `
        -Method Get `
        -WriteErrorTo $PSCmdlet `
        -ErrorAction Stop

    switch ($PsCmdlet.ParameterSetName) {
        'ByDeviceId' {
            Write-Output ($response.resources | ConvertTo-TeamViewerManager -DeviceId $deviceId)
        }
        'ByGroupId' {
            Write-Output ($response.resources | ConvertTo-TeamViewerManager -GroupId $groupId)
        }
    }
}
