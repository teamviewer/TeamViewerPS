function Invoke-TeamViewerPing {
    [CmdletBinding()]

    [OutputType([bool])]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $APIToken
    )

    $ResourceUri = "$(Get-TeamViewerAPIUri)/ping"
    $Result = Invoke-TeamViewerRestMethod `
        -APIToken $APIToken `
        -Uri $ResourceUri `
        -Method Get `
        -WriteErrorTo $PSCmdlet `
        -ErrorAction Stop

    Write-Output $Result.token_valid
}
