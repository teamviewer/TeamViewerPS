function Set-TeamViewerPolicy {
    [CmdletBinding(SupportsShouldProcess = $true, DefaultParameterSetName = 'ByParameters')]

    [OutputType([void])]

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

    $Body = @{}

    switch ($PSCmdlet.ParameterSetName) {
        'ByParameters' {
            if ($Name) {
                $Body['name'] = $Name
            }
            if ($Settings) {
                $Body['settings'] = $Settings
            }
        }
        'ByProperties' {
            @('name', 'settings') | `
                Where-Object { $Property[$_] } | `
                ForEach-Object { $Body[$_] = $Property[$_] }
        }
    }

    if ($Body.Count -eq 0) {
        $PSCmdlet.ThrowTerminatingError(
            ('The given input does not change the policy.' | `
                ConvertTo-ErrorRecord -ErrorCategory InvalidArgument))
    }

    $PolicyId = $Policy | Resolve-TeamViewerPolicyId
    $ResourceUri = "$(Get-TeamViewerApiUri)/teamviewerpolicies/$PolicyId"

    if ($PSCmdlet.ShouldProcess($PolicyId, 'Update policy')) {
        Invoke-TeamViewerRestMethod `
            -ApiToken $ApiToken `
            -Uri $ResourceUri `
            -Method Put `
            -ContentType 'application/json; charset=utf-8' `
            -Body ([System.Text.Encoding]::UTF8.GetBytes(($Body | ConvertTo-Json -Depth 25))) `
            -WriteErrorTo $PSCmdlet | `
            Out-Null
    }
}
