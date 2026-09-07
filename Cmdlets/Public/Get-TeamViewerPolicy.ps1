function Get-TeamViewerPolicy {
    [CmdletBinding(DefaultParameterSetName = 'List')]

    [OutputType('TeamViewerPS.Policy')]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $APIToken,

        [Parameter(ParameterSetName = 'ByPolicyId')]
        [Alias('Id', 'PolicyId')]
        [guid]
        $Policy
    )

    $Resource_Uri = "$(Get-TeamViewerAPIUri)/teamviewerpolicies"
    $Parameters = @{ }

    switch ($PsCmdlet.ParameterSetName) {
        'ByPolicyId' {
            $Resource_Uri += "/$Policy"
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

    Write-Output ($Response.policies | ConvertTo-TeamViewerPolicy)
}
