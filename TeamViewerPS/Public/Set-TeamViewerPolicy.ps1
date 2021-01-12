function Set-TeamViewerPolicy {
    [CmdletBinding(SupportsShouldProcess = $true, DefaultParameterSetName = 'ByParameters')]
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerPolicyId } )]
        [Alias('PolicyId')]
        [object]
        $Policy,

        [Parameter(ParameterSetName = 'ByParameters')]
        [string]
        $Name,

        [Parameter(ParameterSetName = 'ByParameters')]
        [object[]]
        $Settings,

        [Parameter(Mandatory = $true, ParameterSetName = 'ByProperties')]
        [hashtable]
        $Property
    )
    # Warning suppresion doesn't seem to work.
    # See https://github.com/PowerShell/PSScriptAnalyzer/issues/1472
    $null = $Property

    $body = @{}
    switch ($PSCmdlet.ParameterSetName) {
        'ByParameters' {
            if ($Name) {
                $body['name'] = $Name
            }
            if ($Settings) {
                $body['settings'] = $Settings
            }
        }
        'ByProperties' {
            @('name', 'settings') | `
                Where-Object { $Property[$_] } | `
                ForEach-Object { $body[$_] = $Property[$_] }
        }
    }

    if ($body.Count -eq 0) {
        $PSCmdlet.ThrowTerminatingError(
            ("The given input does not change the policy." | `
                    ConvertTo-ErrorRecord -ErrorCategory InvalidArgument))
    }

    $policyId = $Policy | Resolve-TeamViewerPolicyId
    $resourceUri = "$(Get-TeamViewerApiUri)/teamviewerpolicies/$policyId"

    if ($PSCmdlet.ShouldProcess($policyId, "Update policy")) {
        Invoke-TeamViewerRestMethod `
            -ApiToken $ApiToken `
            -Uri $resourceUri `
            -Method Put `
            -ContentType "application/json; charset=utf-8" `
            -Body ([System.Text.Encoding]::UTF8.GetBytes(($body | ConvertTo-Json))) `
            -WriteErrorTo $PSCmdlet | `
            Out-Null
    }
}
