function Get-TeamViewerCompany {
    [CmdletBinding()]

    [OutputType('TeamViewerPS.Company')]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken
    )

    $resourceUri = "$(Get-TeamViewerApiUri)/company"

    $response = Invoke-TeamViewerRestMethod `
        -ApiToken $ApiToken `
        -Uri $resourceUri `
        -Method Get `
        -WriteErrorTo $PSCmdlet `
        -ErrorAction Stop

    Write-Output ($response | ConvertTo-TeamViewerCompany)
}
