function Get-TeamViewerSsoDomain {
    [CmdletBinding(DefaultParameterSetName = 'FilteredList')]

    [OutputType('TeamViewerPS.SsoDomain')]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(ParameterSetName = 'ByDomain')]
        [ValidateScript( { $_ | Resolve-TeamViewerSsoDomainId } )]
        [Alias('Id', 'DomainId', 'SsoDomainId', 'SsoDomain')]
        [guid]
        $Domain
    )

    $ResourceUri = "$(Get-TeamViewerApiUri)/ssoDomain"
    $Parameters = @{ }

    switch ($PsCmdlet.ParameterSetName) {
        'ByDomain' {
            $ResourceUri += "/$Domain"
            $Parameters = $null
        }
    }

    $Response = Invoke-TeamViewerRestMethod `
        -ApiToken $ApiToken `
        -Uri $ResourceUri `
        -Method Get `
        -Body $Parameters `
        -WriteErrorTo $PSCmdlet `
        -ErrorAction Stop

    Write-Output ($Response.domains | ConvertTo-TeamViewerSsoDomain)
}
