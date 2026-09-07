function Get-TeamViewerLicense {
    [CmdletBinding()]

    [OutputType('TeamViewerPS.License')]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $APIToken
    )

    $ResourceUri = "$(Get-TeamViewerAPIUri)/company/license"

    $Response = Invoke-TeamViewerRestMethod `
        -APIToken $APIToken `
        -Uri $ResourceUri `
        -Method Get `
        -WriteErrorTo $PSCmdlet `
        -ErrorAction Stop

    Write-Output ($Response | ConvertTo-TeamViewerLicense)
}
