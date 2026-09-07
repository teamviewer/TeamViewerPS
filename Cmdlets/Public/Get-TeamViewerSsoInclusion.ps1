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

    $Domain_Id = $Domain | Resolve-TeamViewerSSODomainId

    $Resource_Uri = "$(Get-TeamViewerAPIUri)/ssoDomain/$Domain_Id/inclusion"
    $Parameters = @{ }

    do {
        $Response = Invoke-TeamViewerRestMethod `
            -APIToken $APIToken `
            -Uri $Resource_Uri `
            -Method Get `
            -Body $Parameters `
            -WriteErrorTo $PSCmdlet `
            -ErrorAction Stop

        Write-Output $Response.emails

        $Parameters.ct = $Response.continuation_token
    } while ($Parameters.ct)
}
