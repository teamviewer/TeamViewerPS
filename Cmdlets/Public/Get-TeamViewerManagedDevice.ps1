function Get-TeamViewerManagedDevice {
    [CmdletBinding(DefaultParameterSetName = 'List')]

    [OutputType('TeamViewerPS.ManagedDevice')]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(ParameterSetName = 'ByDevice')]
        [ValidateScript( { $_ | Resolve-TeamViewerManagedDeviceId } )]
        [Alias('Id', 'DeviceId')]
        [guid]
        $Device,

        [Parameter(Mandatory = $true, ParameterSetName = 'ListGroup')]
        [ValidateScript( { $_ | Resolve-TeamViewerManagedGroupId } )]
        [Alias('GroupId', 'ManagedGroupId', 'ManagedGroup')]
        [object]
        $Group,

        [Parameter(ParameterSetName = 'ListGroup')]
        [switch]
        $FilterBy_Pending
    )

    # default is 'List':
    $ResourceUri = "$(Get-TeamViewerApiUri)/managed/devices"
    $Parameters = @{ }
    $IsListOperation = $true

    switch ($PsCmdlet.ParameterSetName) {
        'ByDevice' {
            $ResourceUri += "/$Device"
            $Parameters = $null
            $IsListOperation = $false
        }
        'ListGroup' {
            $GroupId = $Group | Resolve-TeamViewerManagedGroupId
            $ResourceUri = "$(Get-TeamViewerApiUri)/managed/groups/$GroupId/$(if ($FilterBy_Pending) { 'pending-' })devices"
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

        if ($PsCmdlet.ParameterSetName -eq 'ByDevice') {
            Write-Output ($Response | ConvertTo-TeamViewerManagedDevice)
        }
        else {
            $Parameters.paginationToken = $Response.nextPaginationToken
            Write-Output ($Response.resources | ConvertTo-TeamViewerManagedDevice)
        }
    } while ($IsListOperation -and $Parameters.paginationToken)
}
