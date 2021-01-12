function Get-TeamViewerManagedDevice {
    [CmdletBinding(DefaultParameterSetName = "List")]
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(ParameterSetName = "ByDeviceId")]
        [ValidateScript( { $_ | Resolve-TeamViewerManagedDeviceId } )]
        [Alias("DeviceId")]
        [guid]
        $Id,

        [Parameter(Mandatory = $true, ParameterSetName = "ListGroup")]
        [ValidateScript( { $_ | Resolve-TeamViewerManagedGroupId } )]
        [Alias("GroupId")]
        [object]
        $Group,

        [Parameter(ParameterSetName = "ListGroup")]
        [switch]
        $Pending
    )

    # default is 'List':
    $resourceUri = "$(Get-TeamViewerApiUri)/managed/devices";
    $parameters = @{ }
    $isListOperation = $true

    switch ($PsCmdlet.ParameterSetName) {
        'ByDeviceId' {
            $resourceUri += "/$Id"
            $parameters = $null
            $isListOperation = $false
        }
        'ListGroup' {
            $groupId = $Group | Resolve-TeamViewerManagedGroupId
            $resourceUri = "$(Get-TeamViewerApiUri)/managed/groups/$groupId/$(if ($Pending) { "pending-" })devices"
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

        if ($PsCmdlet.ParameterSetName -Eq 'ByDeviceId') {
            Write-Output ($response | ConvertTo-TeamViewerManagedDevice)
        }
        else {
            $parameters.paginationToken = $response.nextPaginationToken
            Write-Output ($response.resources | ConvertTo-TeamViewerManagedDevice)
        }
    } while ($isListOperation -And $parameters.paginationToken)
}
