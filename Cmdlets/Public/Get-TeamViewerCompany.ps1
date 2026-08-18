function Get-TeamViewerCompany {
    [CmdletBinding()]

    [OutputType('TeamViewerPS.Company')]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken
    )

    $ResourceUri = "$(Get-TeamViewerApiUri)/company"

    $Response = Invoke-TeamViewerRestMethod `
        -ApiToken $ApiToken `
        -Uri $ResourceUri `
        -Method Get `
        -WriteErrorTo $PSCmdlet `
        -ErrorAction Stop

    Write-Output ($Response | ConvertTo-TeamViewerCompany)
}
