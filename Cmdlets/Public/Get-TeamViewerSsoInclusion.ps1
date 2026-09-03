function Get-TeamViewerSsoInclusion {
    [CmdletBinding()]

    [OutputType([string[]])]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerSsoDomainId } )]
        [Alias('Id', 'DomainId', 'SsoDomainId', 'SsoDomain')]
        [object]
        $Domain
    )

    $DomainId = $Domain | Resolve-TeamViewerSsoDomainId
    $ResourceUri = "$(Get-TeamViewerApiUri)/ssoDomain/$DomainId/inclusion"
    $Parameters = @{ }

    do {
        $Response = Invoke-TeamViewerRestMethod `
            -ApiToken $ApiToken `
            -Uri $ResourceUri `
            -Method Get `
            -Body $Parameters `
            -WriteErrorTo $PSCmdlet `
            -ErrorAction Stop

        Write-Output $Response.emails

        $Parameters.ct = $Response.continuation_token
    } while ($Parameters.ct)
}
