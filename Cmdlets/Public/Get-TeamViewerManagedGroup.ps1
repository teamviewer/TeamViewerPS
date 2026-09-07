function Get-TeamViewerManagedGroup {
    [CmdletBinding(DefaultParameterSetName = 'List')]

    [OutputType('TeamViewerPS.ManagedGroup')]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $APIToken,

        [Parameter(ParameterSetName = 'ByGroupId')]
        [ValidateScript( { $_ | Resolve-TeamViewerManagedGroupId } ) ]
        [Alias('Id', 'GroupId', 'ManagedGroupId', 'ManagedGroup')]
        [guid]
        $Group,

        [Parameter(ParameterSetName = 'ByDeviceId')]
        [ValidateScript( { $_ | Resolve-TeamViewerManagedDeviceId } )]
        [Alias('DeviceId', 'ManagedDeviceId', 'ManagedDevice')]
        [object]
        $Device
    )

    $Resource_Uri = "$(Get-TeamViewerAPIUri)/managed/groups"
    $Parameters = @{ }

    switch ($PsCmdlet.ParameterSetName) {
        'ByGroupId' {
            $Resource_Uri += "/$Group"
            $Parameters = $null
        }
        'ByDeviceId' {
            $DeviceId = $Device | Resolve-TeamViewerManagedDeviceId
            $Resource_Uri = "$(Get-TeamViewerAPIUri)/managed/devices/$DeviceId/groups"
        }
    }

    do {
        $Response = Invoke-TeamViewerRestMethod `
            -APIToken $APIToken `
            -Uri $Resource_Uri `
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
    } while ($PsCmdlet.ParameterSetName -in @('List', 'ByDeviceId') -and $Parameters.paginationToken)
}
