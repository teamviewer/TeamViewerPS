function Set-TeamViewerManagedGroup {
    [CmdletBinding(SupportsShouldProcess = $true, DefaultParameterSetName = 'ByParameters')]
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

    Begin {
        # Warning suppression doesn't seem to work.
        # See https://github.com/PowerShell/PSScriptAnalyzer/issues/1472
        $null = $Property

        $body = @{}
        switch ($PSCmdlet.ParameterSetName) {
            'ByParameters' {
                if ($Name) {
                    $body['name'] = $Name
                }

                if ($PolicyId -or $PolicyType) {
                    if (-not ($PolicyId -and $PolicyType)) {
                        $PSCmdlet.ThrowTerminatingError(
                            ('PolicyId and PolicyType must be specified together' | ConvertTo-ErrorRecord -ErrorCategory InvalidArgument))
                    }
                    $body['policy'] = @{
                        'policy_id' = $PolicyId
                        'policy_type' = $PolicyType
                    }
                }
            }
            'ByProperties' {
                @('name') | Where-Object { $Property[$_] } | ForEach-Object { $body[$_] = $Property[$_] }

                if ($Property.ContainsKey('policy_id') -or $Property.ContainsKey('policy_type')) {
                    if (-not ($Property.ContainsKey('policy_id') -and $Property.ContainsKey('policy_type'))) {
                        $PSCmdlet.ThrowTerminatingError(
                            ('PolicyId and PolicyType must be specified together' | ConvertTo-ErrorRecord -ErrorCategory InvalidArgument))
                    }
                    $body['policy'] = @{
                        'policy_id' = $Property['policy_id']
                        'policy_type' = [PolicyType]$Property['policy_type']
                    }
                }
            }
        }

        if ($body.Count -eq 0) {
            $PSCmdlet.ThrowTerminatingError(
                ('The given input does not change the managed group.' | ConvertTo-ErrorRecord -ErrorCategory InvalidArgument))
        }
    }

    Process {
        $groupId = $Group | Resolve-TeamViewerManagedGroupId
        $resourceUri = "$(Get-TeamViewerApiUri)/managed/groups/$groupId"

        if ($PSCmdlet.ShouldProcess($groupId, 'Update managed group')) {
            Invoke-TeamViewerRestMethod `
                -ApiToken $ApiToken `
                -Uri $resourceUri `
                -Method Put `
                -ContentType 'application/json; charset=utf-8' `
                -Body ([System.Text.Encoding]::UTF8.GetBytes(($body | ConvertTo-Json))) `
                -WriteErrorTo $PSCmdlet | Out-Null
        }
    }
}
