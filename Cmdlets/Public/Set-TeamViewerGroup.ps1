function Set-TeamViewerGroup {
    [CmdletBinding(SupportsShouldProcess = $true, DefaultParameterSetName = 'ByParameters')]

    [OutputType([void])]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerGroupId } )]
        [Alias('GroupId')]
        [Alias('Id')]
        [object]
        $Group,

        [Parameter(ParameterSetName = 'ByParameters')]
        [string]
        $Name,

        [Parameter(ParameterSetName = 'ByParameters')]
        [ValidateScript( { $_ | Resolve-TeamViewerPolicyId } )]
        [Alias('PolicyId')]
        [object]
        $Policy,

        [Parameter(Mandatory = $true, ParameterSetName = 'ByProperties')]
        [hashtable]
        $Property
    )

    begin {
        # Warning suppresion doesn't seem to work.
        # See https://github.com/PowerShell/PSScriptAnalyzer/issues/1472
        $null = $Property

        $Body = @{}

        switch ($PSCmdlet.ParameterSetName) {
            'ByParameters' {
                $Body['name'] = $Name
                if ($Policy) {
                    $Body['policy_id'] = ($Policy | Resolve-TeamViewerPolicyId).ToString()
                }
            }
            'ByProperties' {
                @('name', 'policy_id') | `
                    Where-Object { $Property[$_] } | `
                    ForEach-Object { $Body[$_] = $Property[$_] }
            }
        }

        if ($Body.Count -eq 0) {
            $PSCmdlet.ThrowTerminatingError(
                ('The given input does not change the group.' | `
                    ConvertTo-ErrorRecord -ErrorCategory InvalidArgument))
        }
    }

    process {
        $GroupId = $Group | Resolve-TeamViewerGroupId
        $ResourceUri = "$(Get-TeamViewerApiUri)/groups/$GroupId"

        if ($PSCmdlet.ShouldProcess($GroupId, 'Update group')) {
            Invoke-TeamViewerRestMethod `
                -ApiToken $ApiToken `
                -Uri $ResourceUri `
                -Method Put `
                -ContentType 'application/json; charset=utf-8' `
                -Body ([System.Text.Encoding]::UTF8.GetBytes(($Body | ConvertTo-Json))) `
                -WriteErrorTo $PSCmdlet | Out-Null
        }
    }
}
