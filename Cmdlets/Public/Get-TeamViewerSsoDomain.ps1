function Get-TeamViewerSSODomain {
    [CmdletBinding(DefaultParameterSetName = 'FilteredList')]

    [OutputType('TeamViewerPS.SSODomain')]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $APIToken,

        [Parameter(ParameterSetName = 'ByDomain')]
        [ValidateScript( { $_ | Resolve-TeamViewerSSODomainId } )]
        [Alias('Id', 'DomainId', 'SSODomainId', 'SSODomain')]
        [guid]
        $Domain
    )

    $ResourceUri = "$(Get-TeamViewerAPIUri)/ssoDomain"
    $Parameters = @{ }

    switch ($PsCmdlet.ParameterSetName) {
        'ByDomain' {
            $ResourceUri += "/$Domain"
            $Parameters = $null
        }
    }

    $Response = Invoke-TeamViewerRestMethod `
        -APIToken $APIToken `
        -Uri $ResourceUri `
        -Method Get `
        -Body $Parameters `
        -WriteErrorTo $PSCmdlet `
        -ErrorAction Stop

    Write-Output ($Response.domains | ConvertTo-TeamViewerSSODomain)
}
