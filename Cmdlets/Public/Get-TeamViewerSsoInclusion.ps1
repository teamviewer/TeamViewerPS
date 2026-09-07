function Get-TeamViewerSSOInclusion {
    [CmdletBinding()]

    [OutputType([string[]])]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $APIToken,

        [Parameter(Mandatory = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerSSODomainId } )]
        [Alias('Id', 'DomainId', 'SSODomainId', 'SSODomain')]
        [object]
        $Domain
    )

    $DomainId = $Domain | Resolve-TeamViewerSSODomainId
    $ResourceUri = "$(Get-TeamViewerAPIUri)/ssoDomain/$DomainId/inclusion"
    $Parameters = @{ }

    do {
        $Response = Invoke-TeamViewerRestMethod `
            -APIToken $APIToken `
            -Uri $ResourceUri `
            -Method Get `
            -Body $Parameters `
            -WriteErrorTo $PSCmdlet `
            -ErrorAction Stop

        Write-Output $Response.emails

        $Parameters.ct = $Response.continuation_token
    } while ($Parameters.ct)
}
