function Get-TeamViewerSsoDomain {
    [CmdletBinding(DefaultParameterSetName = 'FilteredList')]

    [OutputType('TeamViewerPS.SsoDomain')]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(ParameterSetName = 'ByDomainId')]
        [Alias('DomainId')]
        [guid]
        $Id
    )

    $ResourceUri = "$(Get-TeamViewerApiUri)/ssoDomain"
    $Parameters = @{ }

    switch ($PsCmdlet.ParameterSetName) {
        'ByDomainId' {
            $ResourceUri += "/$Id"
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
