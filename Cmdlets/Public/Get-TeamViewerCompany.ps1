function Get-TeamViewerCompany {
    [CmdletBinding()]

    [OutputType('TeamViewerPS.Company')]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $APIToken
    )

    $ResourceUri = "$(Get-TeamViewerAPIUri)/company"

    $Response = Invoke-TeamViewerRestMethod `
        -APIToken $APIToken `
        -Uri $ResourceUri `
        -Method Get `
        -WriteErrorTo $PSCmdlet `
        -ErrorAction Stop

    Write-Output ($Response | ConvertTo-TeamViewerCompany)
}
