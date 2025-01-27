function New-TeamViewerOrganizationalUnit {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true)]
        [string]
        $Name,

        [Parameter(Mandatory = $false)]
        [string]
        $Description,

        [Parameter(Mandatory = $false)]
        [string]
        $Parent
    )

    $body = @{ name = $Name }

    if ($Description) {
        $body = @{ description = $Description }
    }

    if ($Parent) {
        $body = @{ parentId = $Parent }
    }

    $resourceUri = "$(Get-TeamViewerApiUri)/organizationalunits"

    if ($PSCmdlet.ShouldProcess($Name, 'Create organizational unit')) {
        $response = Invoke-TeamViewerRestMethod `
            -ApiToken $ApiToken `
            -Uri $resourceUri `
            -Method Post `
            -ContentType 'application/json; charset=utf-8' `
            -Body ([System.Text.Encoding]::UTF8.GetBytes(($body | ConvertTo-Json))) `
            -WriteErrorTo $PSCmdlet `
            -ErrorAction Stop
        Write-Output ($response | ConvertTo-TeamViewerOrganizationalUnit)
    }
}
