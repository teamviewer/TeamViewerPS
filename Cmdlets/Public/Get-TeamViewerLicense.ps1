function Get-TeamViewerLicense {
    [CmdletBinding()]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken
    )

    $resourceUri = "$(Get-TeamViewerApiUri)/company/license"

    $response = Invoke-TeamViewerRestMethod `
        -ApiToken $ApiToken `
        -Uri $resourceUri `
        -Method Get `
        -WriteErrorTo $PSCmdlet `
        -ErrorAction Stop

    Write-Output ($response | ConvertTo-TeamViewerLicense)
}
