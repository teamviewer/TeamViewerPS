function Remove-TeamViewerPolicy {
    [CmdletBinding(SupportsShouldProcess = $true, DefaultParameterSetName = 'ByParameters')]
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerPolicyId } )]
        [Alias('PolicyId')]
        [object]
        $Policy
    )
    Process {
        $policyId = $Policy | Resolve-TeamViewerPolicyId
        $resourceUri = "$(Get-TeamViewerApiUri)/teamviewerpolicies/$policyId"

        if ($PSCmdlet.ShouldProcess($policyId, "Delete policy")) {
            Invoke-TeamViewerRestMethod `
                -ApiToken $ApiToken `
                -Uri $resourceUri `
                -Method Delete `
                -WriteErrorTo $PSCmdlet | `
                Out-Null
        }
    }
}
