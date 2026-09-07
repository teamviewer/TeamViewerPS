function Add-TeamViewerManagedDevice {
    [CmdletBinding(SupportsShouldProcess = $true)]

    [OutputType([void])]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $APIToken,

        [Parameter(Mandatory = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerManagedDeviceId } )]
        [Alias('Id', 'DeviceId', 'ManagedDeviceId', 'ManagedDevice')]
        [object]
        $Device,

        [Parameter(Mandatory = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerManagedGroupId } )]
        [Alias('GroupId', 'ManagedGroupId', 'ManagedGroup')]
        [object]
        $Group
    )

    $Device_Id = $Device | Resolve-TeamViewerManagedDeviceId
    $Group_Id = $Group | Resolve-TeamViewerManagedGroupId
    $Resource_Uri = "$(Get-TeamViewerAPIUri)/managed/groups/$Group_Id/devices"

    $Body = @{
        Id = $Device_Id.ToString()
    }

    if ($PSCmdlet.ShouldProcess($Device_Id, 'Add device to managed group')) {
        Invoke-TeamViewerRestMethod `
            -APIToken $APIToken `
            -Uri $Resource_Uri `
            -Method Post `
            -ContentType 'application/json; charset=utf-8' `
            -Body ([System.Text.Encoding]::UTF8.GetBytes(($Body | ConvertTo-Json))) `
            -WriteErrorTo $PSCmdlet | Out-Null
    }
}
