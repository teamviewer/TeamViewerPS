function Get-TeamViewerLicense {
    [CmdletBinding()]

    [OutputType('TeamViewerPS.License')]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $APIToken
    )

    $Resource_Uri = "$(Get-TeamViewerAPIUri)/company/license"

    $Response = Invoke-TeamViewerRestMethod `
        -APIToken $APIToken `
        -Uri $Resource_Uri `
        -Method Get `
        -WriteErrorTo $PSCmdlet `
        -ErrorAction Stop

    Write-Output ($Response | ConvertTo-TeamViewerLicense)
}
