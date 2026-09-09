function Get-TeamViewerManager {
    [CmdletBinding(DefaultParameterSetName = 'ByDeviceId')]

    [OutputType('TeamViewerPS.Manager')]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $APIToken,

        [Parameter(Mandatory = $true, ParameterSetName = 'ByDeviceId')]
        [ValidateScript( { $_ | Resolve-TeamViewerManagedDeviceId } )]
        [Alias('Id', 'DeviceId', 'ManagedDeviceId', 'ManagedDevice')]
        [object]
        $Device,

        [Parameter(Mandatory = $true, ParameterSetName = 'ByGroupId')]
        [ValidateScript( { $_ | Resolve-TeamViewerManagedGroupId } )]
        [Alias('GroupId', 'ManagedGroupId', 'ManagedGroup')]
        [object]
        $Group
    )

    $Resource_Uri = $null

    switch ($PsCmdlet.ParameterSetName) {
        'ByDeviceId' {
            $DeviceId = $Device | Resolve-TeamViewerManagedDeviceId
            $Resource_Uri = "$(Get-TeamViewerAPIUri)/managed/devices/$DeviceId/managers"
        }
        'ByGroupId' {
            $GroupId = $Group | Resolve-TeamViewerManagedGroupId
            $Resource_Uri = "$(Get-TeamViewerAPIUri)/managed/groups/$GroupId/managers"
        }
    }

    $Response = Invoke-TeamViewerRestMethod `
        -APIToken $APIToken `
        -Uri $Resource_Uri `
        -Method Get `
        -WriteErrorTo $PSCmdlet `
        -ErrorAction Stop

    switch ($PsCmdlet.ParameterSetName) {
        'ByDeviceId' {
            Write-Output ($Response.resources | ConvertTo-TeamViewerManager -Device $DeviceId )
        }
        'ByGroupId' {
            Write-Output ($Response.resources | ConvertTo-TeamViewerManager -Group $GroupId)
        }
    }
}
