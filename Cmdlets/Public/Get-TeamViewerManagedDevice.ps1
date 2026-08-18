function Get-TeamViewerManagedDevice {
    [CmdletBinding(DefaultParameterSetName = 'List')]

    [OutputType('TeamViewerPS.ManagedDevice')]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(ParameterSetName = 'ByDeviceId')]
        [ValidateScript( { $_ | Resolve-TeamViewerManagedDeviceId } )]
        [Alias('DeviceId')]
        [Alias('Device')]
        [guid]
        $Id,

        [Parameter(Mandatory = $true, ParameterSetName = 'ListGroup')]
        [ValidateScript( { $_ | Resolve-TeamViewerManagedGroupId } )]
        [Alias('GroupId')]
        [object]
        $Group,

        [Parameter(ParameterSetName = 'ListGroup')]
        [switch]
        $Pending
    )

    # default is 'List':
    $ResourceUri = "$(Get-TeamViewerApiUri)/managed/devices"
    $Parameters = @{ }
    $IsListOperation = $true

    switch ($PsCmdlet.ParameterSetName) {
        'ByDeviceId' {
            $ResourceUri += "/$Id"
            $Parameters = $null
            $IsListOperation = $false
        }
        'ListGroup' {
            $GroupId = $Group | Resolve-TeamViewerManagedGroupId
            $ResourceUri = "$(Get-TeamViewerApiUri)/managed/groups/$GroupId/$(if ($Pending) { 'pending-' })devices"
        }
    }

    do {
        $Response = Invoke-TeamViewerRestMethod `
            -ApiToken $ApiToken `
            -Uri $ResourceUri `
            -Method Get `
            -Body $Parameters `
            -WriteErrorTo $PSCmdlet `
            -ErrorAction Stop

        if ($PsCmdlet.ParameterSetName -eq 'ByDeviceId') {
            Write-Output ($Response | ConvertTo-TeamViewerManagedDevice)
        }
        else {
            $Parameters.paginationToken = $Response.nextPaginationToken
            Write-Output ($Response.resources | ConvertTo-TeamViewerManagedDevice)
        }
    } while ($IsListOperation -and $Parameters.paginationToken)
}
