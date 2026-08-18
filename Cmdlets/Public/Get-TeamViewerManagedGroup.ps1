function Get-TeamViewerManagedGroup {
    [CmdletBinding(DefaultParameterSetName = 'List')]

    [OutputType('TeamViewerPS.ManagedGroup')]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(ParameterSetName = 'ByGroupId')]
        [ValidateScript( { $_ | Resolve-TeamViewerManagedGroupId } ) ]
        [Alias('GroupId')]
        [guid]
        $Id,

        [Parameter(ParameterSetName = 'ByDeviceId')]
        [ValidateScript( { $_ | Resolve-TeamViewerManagedDeviceId } )]
        [Alias('DeviceId')]
        [object]
        $Device
    )

    $ResourceUri = "$(Get-TeamViewerApiUri)/managed/groups"
    $Parameters = @{ }

    switch ($PsCmdlet.ParameterSetName) {
        'ByGroupId' {
            $ResourceUri += "/$Id"
            $Parameters = $null
        }
        'ByDeviceId' {
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

        if ($PsCmdlet.ParameterSetName -eq 'ByGroupId') {
            Write-Output ($Response | ConvertTo-TeamViewerManagedGroup)
        }
        else {
            $Parameters.paginationToken = $Response.nextPaginationToken
            Write-Output ($Response.resources | ConvertTo-TeamViewerManagedGroup)
        }
    } while ($PsCmdlet.ParameterSetName -in @('List', 'ByDeviceId') `
            -and $Parameters.paginationToken)
}
