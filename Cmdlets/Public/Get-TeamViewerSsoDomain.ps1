function Get-TeamViewerSSODomain {
    [CmdletBinding(DefaultParameterSetName = 'List')]

    [OutputType('TeamViewerPS.SSODomain')]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $APIToken,

        [Parameter(ParameterSetName = 'ByDomainId')]
        [ValidateScript( { $_ | Resolve-TeamViewerSSODomainId } )]
        [Alias('Id', 'DomainId', 'SSODomainId', 'SSODomain')]
        [guid]
        $Domain
    )

    $Resource_Uri = "$(Get-TeamViewerAPIUri)/ssoDomain"
    $Parameters = @{ }

    switch ($PsCmdlet.ParameterSetName) {
        'ByDomainId' {
            $Resource_Uri += "/$Domain"
            $Parameters = $null
        }
    }

    $Response = Invoke-TeamViewerRestMethod `
        -APIToken $APIToken `
        -Uri $Resource_Uri `
        -Method Get `
        -Body $Parameters `
        -WriteErrorTo $PSCmdlet `
        -ErrorAction Stop

    Write-Output ($Response.domains | ConvertTo-TeamViewerSSODomain)
}
