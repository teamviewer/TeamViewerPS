function Get-TeamViewerLicense {
    [CmdletBinding()]

    [OutputType('TeamViewerPS.License')]

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
