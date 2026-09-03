function Get-TeamViewerManagedGroup {
    [CmdletBinding(DefaultParameterSetName = 'List')]

    [OutputType('TeamViewerPS.ManagedGroup')]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(ParameterSetName = 'ByGroup')]
        [ValidateScript( { $_ | Resolve-TeamViewerManagedGroupId } ) ]
        [Alias('Id', 'GroupId', 'ManagedGroupId', 'ManagedGroup')]
        [guid]
        $Group,

        [Parameter(ParameterSetName = 'ByDevice')]
        [ValidateScript( { $_ | Resolve-TeamViewerManagedDeviceId } )]
        [Alias('DeviceId', 'ManagedDeviceId', 'ManagedDevice')]
        [object]
        $Device
    )

    $ResourceUri = "$(Get-TeamViewerApiUri)/managed/groups"
    $Parameters = @{ }

    switch ($PsCmdlet.ParameterSetName) {
        'ByGroup' {
            $ResourceUri += "/$Group"
            $Parameters = $null
        }
        'ByDevice' {
            $DeviceId = $Device | Resolve-TeamViewerManagedDeviceId
            $ResourceUri = "$(Get-TeamViewerApiUri)/managed/devices/$DeviceId/groups"
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

        if ($PsCmdlet.ParameterSetName -eq 'ByGroup') {
            Write-Output ($Response | ConvertTo-TeamViewerManagedGroup)
        }
        else {
            $Parameters.paginationToken = $Response.nextPaginationToken
            Write-Output ($Response.resources | ConvertTo-TeamViewerManagedGroup)
        }
    } while ($PsCmdlet.ParameterSetName -in @('List', 'ByDevice') `
            -and $Parameters.paginationToken)
}
