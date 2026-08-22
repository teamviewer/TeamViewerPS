function Add-TeamViewerManagedDevice {
    [CmdletBinding(SupportsShouldProcess = $true)]

    [OutputType([void])]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerManagedDeviceId } )]
        [Alias('DeviceId')]
        [object]
        $Device,

        [Parameter(Mandatory = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerManagedGroupId } )]
        [Alias('GroupId')]
        [object]
        $Group
    )

    $DeviceId = $Device | Resolve-TeamViewerManagedDeviceId
    $GroupId = $Group | Resolve-TeamViewerManagedGroupId
    $ResourceUri = "$(Get-TeamViewerApiUri)/managed/groups/$GroupId/devices"

    $Body = @{
        Id = $DeviceId.ToString()
    }

    if ($PSCmdlet.ShouldProcess($DeviceId, 'Add device to managed group')) {
        Invoke-TeamViewerRestMethod `
            -ApiToken $ApiToken `
            -Uri $ResourceUri `
            -Method Post `
            -ContentType 'application/json; charset=utf-8' `
            -Body ([System.Text.Encoding]::UTF8.GetBytes(($Body | ConvertTo-Json))) `
            -WriteErrorTo $PSCmdlet | Out-Null
    }
}
