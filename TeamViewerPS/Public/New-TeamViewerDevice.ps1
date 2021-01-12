function New-TeamViewerDevice {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true)]
        [int]
        $TeamViewerId,

        [Parameter(Mandatory = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerGroupId } )]
        [Alias("GroupId")]
        [object]
        $Group,

        [Parameter()]
        [Alias("Alias")]
        [string]
        $Name,

        [Parameter()]
        [string]
        $Description,

        [Parameter()]
        [securestring]
        $Password
    )

    $body = @{
        remotecontrol_id = "r$TeamViewerId"
        groupid          = $Group | Resolve-TeamViewerGroupId
    }

    if ($Name) {
        $body['alias'] = $Name
    }
    if ($Description) {
        $body['description'] = $Description
    }
    if ($Password) {
        $bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($Password)
        $body['password'] = [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($bstr)
        [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr) | Out-Null
    }

    $resourceUri = "$(Get-TeamViewerApiUri)/devices"
    if ($PSCmdlet.ShouldProcess($TeamViewerId, "Create device entry")) {
        $response = Invoke-TeamViewerRestMethod `
            -ApiToken $ApiToken `
            -Uri $resourceUri `
            -Method Post `
            -ContentType "application/json; charset=utf-8" `
            -Body ([System.Text.Encoding]::UTF8.GetBytes(($body | ConvertTo-Json))) `
            -WriteErrorTo $PSCmdlet `
            -ErrorAction Stop

        $result = ($response | ConvertTo-TeamViewerDevice)
        Write-Output $result
    }
}
