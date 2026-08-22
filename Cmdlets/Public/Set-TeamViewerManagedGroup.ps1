function Set-TeamViewerManagedGroup {
    [CmdletBinding(SupportsShouldProcess = $true, DefaultParameterSetName = 'ByParameters')]

    [OutputType([void])]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerManagedGroupId })]
        [Alias('GroupId')]
        [Alias('Id')]
        [object]
        $Group,

        [Parameter(ParameterSetName = 'ByParameters')]
        [string]
        $Name,

        [Parameter(ParameterSetName = 'ByParameters')]
        [ValidateScript( { $_ | Resolve-TeamViewerPolicyId } )]
        [Alias('Policy')]
        [object]
        $PolicyId,

        [Parameter(ParameterSetName = 'ByParameters')]
        [PolicyType]
        $PolicyType,

        [Parameter(Mandatory = $true, ParameterSetName = 'ByProperties')]
        [hashtable]
        $Property
    )

    begin {
        # Warning suppression doesn't seem to work.
        # See https://github.com/PowerShell/PSScriptAnalyzer/issues/1472
        $null = $Property

        $Body = @{}

        switch ($PSCmdlet.ParameterSetName) {
            'ByParameters' {
                if ($Name) {
                    $Body['name'] = $Name
                }

                if ($PolicyId -or $PolicyType) {
                    if (-not ($PolicyId -and $PolicyType)) {
                        $PSCmdlet.ThrowTerminatingError(
                            ('PolicyId and PolicyType must be specified together' | ConvertTo-ErrorRecord -ErrorCategory InvalidArgument))
                    }

                    $Body['policy'] = @{
                        'policy_id'   = $PolicyId
                        'policy_type' = $PolicyType
                    }
                }
            }

            'ByProperties' {
                @('name') | Where-Object { $Property[$_] } | ForEach-Object { $Body[$_] = $Property[$_] }

                if ($Property.ContainsKey('policy_id') -or $Property.ContainsKey('policy_type')) {
                    if (-not ($Property.ContainsKey('policy_id') -and $Property.ContainsKey('policy_type'))) {
                        $PSCmdlet.ThrowTerminatingError(
                            ('PolicyId and PolicyType must be specified together' | ConvertTo-ErrorRecord -ErrorCategory InvalidArgument))
                    }

                    $Body['policy'] = @{
                        'policy_id'   = $Property['policy_id']
                        'policy_type' = [PolicyType]$Property['policy_type']
                    }
                }
            }
        }

        if ($Body.Count -eq 0) {
            $PSCmdlet.ThrowTerminatingError(
                ('The given input does not change the managed group.' | ConvertTo-ErrorRecord -ErrorCategory InvalidArgument))
        }
    }

    process {
        $GroupId = $Group | Resolve-TeamViewerManagedGroupId
        $ResourceUri = "$(Get-TeamViewerApiUri)/managed/groups/$GroupId"

        if ($PSCmdlet.ShouldProcess($GroupId, 'Update managed group')) {
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
