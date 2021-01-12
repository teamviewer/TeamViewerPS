function Set-TeamViewerGroup {
    [CmdletBinding(SupportsShouldProcess = $true, DefaultParameterSetName = 'ByParameters')]
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerGroupId } )]
        [Alias("GroupId")]
        [Alias("Id")]
        [object]
        $Group,

        [Parameter(ParameterSetName = 'ByParameters')]
        [string]
        $Name,

        [Parameter(ParameterSetName = 'ByParameters')]
        [ValidateScript( { $_ | Resolve-TeamViewerPolicyId } )]
        [Alias("PolicyId")]
        [object]
        $Policy,

        [Parameter(Mandatory = $true, ParameterSetName = 'ByProperties')]
        [hashtable]
        $Property
    )
    Begin {
        # Warning suppresion doesn't seem to work.
        # See https://github.com/PowerShell/PSScriptAnalyzer/issues/1472
        $null = $Property

        $body = @{}
        switch ($PSCmdlet.ParameterSetName) {
            'ByParameters' {
                $body['name'] = $Name
                if ($Policy) {
                    $body['policy_id'] = $Policy | Resolve-TeamViewerPolicyId
                }
            }
            'ByProperties' {
                @('name', 'policy_id') | `
                    Where-Object { $Property[$_] } | `
                    ForEach-Object { $body[$_] = $Property[$_] }
            }
        }

        if ($body.Count -eq 0) {
            $PSCmdlet.ThrowTerminatingError(
                ("The given input does not change the group." | `
                        ConvertTo-ErrorRecord -ErrorCategory InvalidArgument))
        }
    }
    Process {
        $groupId = $Group | Resolve-TeamViewerGroupId
        $resourceUri = "$(Get-TeamViewerApiUri)/groups/$groupId"

        if ($PSCmdlet.ShouldProcess($groupId, "Update group")) {
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
}
