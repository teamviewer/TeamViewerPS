function Get-TeamViewerPolicy {
    [CmdletBinding(DefaultParameterSetName = "FilteredList")]
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(ParameterSetName = "ByPolicyId")]
        [Alias("PolicyId")]
        [guid]
        $Id
    )

    $resourceUri = "$(Get-TeamViewerApiUri)/teamviewerpolicies";
    $parameters = @{ }

    switch ($PsCmdlet.ParameterSetName) {
        'ByPolicyId' {
            $resourceUri += "/$Id"
            $parameters = $null
        }
    }

    $response = Invoke-TeamViewerRestMethod `
        -ApiToken $ApiToken `
        -Uri $resourceUri `
        -Method Get `
        -Body $parameters `
        -WriteErrorTo $PSCmdlet `
        -ErrorAction Stop

    Write-Output ($response.policies | ConvertTo-TeamViewerPolicy)
}

