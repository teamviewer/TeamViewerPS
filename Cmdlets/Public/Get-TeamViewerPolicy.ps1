function Get-TeamViewerPolicy {
    [CmdletBinding(DefaultParameterSetName = 'FilteredList')]

    [OutputType('TeamViewerPS.Policy')]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(ParameterSetName = 'ByPolicy')]
        [Alias('Id', 'PolicyId')]
        [guid]
        $Policy
    )

    $ResourceUri = "$(Get-TeamViewerApiUri)/teamviewerpolicies"
    $Parameters = @{ }

    switch ($PsCmdlet.ParameterSetName) {
        'ByPolicy' {
            $ResourceUri += "/$Policy"
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

    Write-Output ($Response.policies | ConvertTo-TeamViewerPolicy)
}
