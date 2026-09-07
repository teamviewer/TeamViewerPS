function Get-TeamViewerAccount {
    [CmdletBinding()]

    [OutputType('TeamViewerPS.Account')]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $APIToken
    )

    $Resource_Uri = "$(Get-TeamViewerAPIUri)/account"

    $Response = Invoke-TeamViewerRestMethod `
        -APIToken $APIToken `
        -Uri $Resource_Uri `
        -Method Get `
        -WriteErrorTo $PSCmdlet `
        -ErrorAction Stop

    Write-Output ($Response | ConvertTo-TeamViewerAccount)
}
