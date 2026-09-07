function Remove-TeamViewerPolicy {
    [CmdletBinding(SupportsShouldProcess = $true)]

    [OutputType([void])]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $APIToken,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerPolicyId } )]
        [Alias('Id', 'PolicyId')]
        [object]
        $Policy
    )

    process {
        $PolicyId = $Policy | Resolve-TeamViewerPolicyId
        $Resource_Uri = "$(Get-TeamViewerAPIUri)/teamviewerpolicies/$PolicyId"

        if ($PSCmdlet.ShouldProcess($PolicyId, 'Delete policy')) {
            Invoke-TeamViewerRestMethod `
                -APIToken $APIToken `
                -Uri $Resource_Uri `
                -Method Delete `
                -WriteErrorTo $PSCmdlet | `
                Out-Null
        }
    }
}
