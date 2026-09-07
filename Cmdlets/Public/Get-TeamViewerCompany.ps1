function Get-TeamViewerCompany {
    [CmdletBinding()]

    [OutputType('TeamViewerPS.Company')]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $APIToken
    )

    $Resource_Uri = "$(Get-TeamViewerAPIUri)/company"

    $Response = Invoke-TeamViewerRestMethod `
        -APIToken $APIToken `
        -Uri $Resource_Uri `
        -Method Get `
        -WriteErrorTo $PSCmdlet `
        -ErrorAction Stop

    Write-Output ($Response | ConvertTo-TeamViewerCompany)
}
