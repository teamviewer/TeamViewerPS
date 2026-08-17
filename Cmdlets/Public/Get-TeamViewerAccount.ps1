function Get-TeamViewerAccount {
    [CmdletBinding()]

    [OutputType('TeamViewerPS.Account')]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken
    )

    $resourceUri = "$(Get-TeamViewerApiUri)/account"

    $response = Invoke-TeamViewerRestMethod `
        -ApiToken $ApiToken `
        -Uri $resourceUri `
        -Method Get `
        -WriteErrorTo $PSCmdlet `
        -ErrorAction Stop

    Write-Output ($response | ConvertTo-TeamViewerAccount)
}
