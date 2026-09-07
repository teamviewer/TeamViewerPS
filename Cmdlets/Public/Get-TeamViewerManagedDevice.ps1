function Get-TeamViewerManagedDevice {
    [CmdletBinding(DefaultParameterSetName = 'List')]

    [OutputType('TeamViewerPS.ManagedDevice')]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $APIToken,

        [Parameter(ParameterSetName = 'ByDeviceId')]
        [ValidateScript( { $_ | Resolve-TeamViewerManagedDeviceId } )]
        [Alias('Id', 'DeviceId', 'ManagedDeviceId', 'ManagedDevice')]
        [guid]
        $Device,

        [Parameter(Mandatory = $true, ParameterSetName = 'ByManagedGroupId')]
        [ValidateScript( { $_ | Resolve-TeamViewerManagedGroupId } )]
        [Alias('GroupId', 'ManagedGroupId', 'ManagedGroup')]
        [object]
        $Group,

        [Parameter(ParameterSetName = 'ByManagedGroupId')]
        [switch]
        $FilterBy_Pending
    )

    $Resource_Uri = "$(Get-TeamViewerAPIUri)/managed/devices"
    $Parameters = @{ }
    $IsListOperation = $true

    switch ($PsCmdlet.ParameterSetName) {
        'ByDeviceId' {
            $Resource_Uri += "/$Device"
            $Parameters = $null
            $IsListOperation = $false
        }
        'ByManagedGroupId' {
            $GroupId = $Group | Resolve-TeamViewerManagedGroupId
            $Resource_Uri = "$(Get-TeamViewerAPIUri)/managed/groups/$GroupId/$(if ($FilterBy_Pending) { 'pending-' })devices"
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

        if ($PsCmdlet.ParameterSetName -eq 'ByDeviceId') {
            Write-Output ($Response | ConvertTo-TeamViewerManagedDevice)
        }
        else {
            $Parameters.paginationToken = $Response.nextPaginationToken
            Write-Output ($Response.resources | ConvertTo-TeamViewerManagedDevice)
        }
    } while ($IsListOperation -and $Parameters.paginationToken)
}
