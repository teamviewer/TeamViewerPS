function Get-TeamViewerManagedGroup {
    [CmdletBinding(DefaultParameterSetName = "List")]
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(ParameterSetName = "ByGroupId")]
        [ValidateScript( { $_ | Resolve-TeamViewerManagedGroupId } ) ]
        [Alias("GroupId")]
        [guid]
        $Id,

        [Parameter(ParameterSetName = "ByDeviceId")]
        [ValidateScript( { $_ | Resolve-TeamViewerManagedDeviceId } )]
        [Alias("DeviceId")]
        [object]
        $Device
    )

    $resourceUri = "$(Get-TeamViewerApiUri)/managed/groups"
    $parameters = @{ }

    switch ($PsCmdlet.ParameterSetName) {
        'ByGroupId' {
            $resourceUri += "/$Id"
            $parameters = $null
        }
        'ByDeviceId' {
            $deviceId = $Device | Resolve-TeamViewerManagedDeviceId
            $resourceUri = "$(Get-TeamViewerApiUri)/managed/devices/$deviceId/groups"
        }
    }

    do {
        $response = Invoke-TeamViewerRestMethod `
            -ApiToken $ApiToken `
            -Uri $resourceUri `
            -Method Get `
            -Body $parameters `
            -WriteErrorTo $PSCmdlet `
            -ErrorAction Stop

        if ($PsCmdlet.ParameterSetName -Eq 'ByGroupId') {
            Write-Output ($response | ConvertTo-TeamViewerManagedGroup)
        }
        else {
            $parameters.paginationToken = $response.nextPaginationToken
            Write-Output ($response.resources | ConvertTo-TeamViewerManagedGroup)
        }
    } while ($PsCmdlet.ParameterSetName -In @('List', 'ByDeviceId') `
            -And $parameters.paginationToken)
}
