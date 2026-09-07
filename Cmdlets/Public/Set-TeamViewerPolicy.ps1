function Set-TeamViewerPolicy {
    [CmdletBinding(SupportsShouldProcess = $true, DefaultParameterSetName = 'ByParameters')]

    [OutputType([void])]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $APIToken,

        [Parameter(Mandatory = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerPolicyId } )]
        [Alias('Id', 'PolicyId')]
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

    $null = $Property # https://github.com/PowerShell/PSScriptAnalyzer/issues/1472

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
    $Resource_Uri = "$(Get-TeamViewerAPIUri)/teamviewerpolicies/$PolicyId"

    if ($PSCmdlet.ShouldProcess($PolicyId, 'Update policy')) {
        Invoke-TeamViewerRestMethod `
            -APIToken $APIToken `
            -Uri $Resource_Uri `
            -Method Put `
            -ContentType 'application/json; charset=utf-8' `
            -Body ([System.Text.Encoding]::UTF8.GetBytes(($Body | ConvertTo-Json -Depth 25))) `
            -WriteErrorTo $PSCmdlet | `
            Out-Null
    }
}
