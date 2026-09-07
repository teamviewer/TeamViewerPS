function Invoke-TeamViewerPing {
    [CmdletBinding()]

    [OutputType([bool])]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $APIToken
    )

    $Resource_Uri = "$(Get-TeamViewerAPIUri)/ping"

    $Result = Invoke-TeamViewerRestMethod `
        -APIToken $APIToken `
        -Uri $Resource_Uri `
        -Method Get `
        -WriteErrorTo $PSCmdlet `
        -ErrorAction Stop

    Write-Output $Result.token_valid
}
