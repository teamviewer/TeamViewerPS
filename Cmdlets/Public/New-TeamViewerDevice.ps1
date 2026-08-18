function New-TeamViewerDevice {
    [CmdletBinding(SupportsShouldProcess = $true)]

    [OutputType('TeamViewerPS.Device')]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true)]
        [ValidateRange(1, [int]::MaxValue)]
        [int]
        $TeamViewerId,

        [Parameter(Mandatory = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerGroupId } )]
        [Alias('GroupId')]
        [object]
        $Group,

        [Parameter()]
        [Alias('Alias')]
        [string]
        $Name,

        [Parameter()]
        [string]
        $Description,

        [Parameter()]
        [securestring]
        $Password
    )

    $Body = @{
        remotecontrol_id = "r$TeamViewerId"
        groupid          = $Group | Resolve-TeamViewerGroupId
    }

    if ($Name) {
        $Body['alias'] = $Name
    }

    if ($Description) {
        $Body['description'] = $Description
    }

    if ($Password) {
        $bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($Password)
        $Body['password'] = [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($bstr)
        [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr) | Out-Null
    }

    $ResourceUri = "$(Get-TeamViewerApiUri)/devices"

    if ($PSCmdlet.ShouldProcess($TeamViewerId, 'Create device entry')) {
        $Response = Invoke-TeamViewerRestMethod `
            -ApiToken $ApiToken `
            -Uri $ResourceUri `
            -Method Post `
            -ContentType 'application/json; charset=utf-8' `
            -Body ([System.Text.Encoding]::UTF8.GetBytes(($Body | ConvertTo-Json))) `
            -WriteErrorTo $PSCmdlet `
            -ErrorAction Stop

        Write-Output ($Response | ConvertTo-TeamViewerDevice)
    }
}
