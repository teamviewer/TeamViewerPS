function Invoke-TeamViewerPing {
    [CmdletBinding()]

    [OutputType([bool])]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken
    )

    $ResourceUri = "$(Get-TeamViewerApiUri)/ping"
    $Result = Invoke-TeamViewerRestMethod `
        -ApiToken $ApiToken `
        -Uri $ResourceUri `
        -Method Get `
        -WriteErrorTo $PSCmdlet `
        -ErrorAction Stop

    Write-Output $Result.token_valid
}
