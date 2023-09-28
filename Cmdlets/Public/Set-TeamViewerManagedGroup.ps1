function Set-TeamViewerManagedGroup {
    [CmdletBinding(SupportsShouldProcess = $true, DefaultParameterSetName = 'ByParameters')]
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerManagedGroupId })]
        [Alias("GroupId")]
        [Alias("Id")]
        [object]
        $Group,

        [Parameter(Mandatory = $true, ParameterSetName = 'ByParameters')]
        [string]
        $Name,

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
            }
            'ByProperties' {
                @('name') | `
                    Where-Object { $Property[$_] } | `
                    ForEach-Object { $body[$_] = $Property[$_] }
            }
        }

        if ($body.Count -eq 0) {
            $PSCmdlet.ThrowTerminatingError(
                ("The given input does not change the managed group." | `
                        ConvertTo-ErrorRecord -ErrorCategory InvalidArgument))
        }
    }
    Process {
        $groupId = $Group | Resolve-TeamViewerManagedGroupId
        $resourceUri = "$(Get-TeamViewerApiUri)/managed/groups/$groupId"

        if ($PSCmdlet.ShouldProcess($groupId, "Update managed group")) {
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
