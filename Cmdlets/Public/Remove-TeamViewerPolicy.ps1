function Remove-TeamViewerPolicy {
    [CmdletBinding(SupportsShouldProcess = $true, DefaultParameterSetName = 'ByParameters')]

    [OutputType([void])]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $APIToken,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerPolicyId } )]
        [Alias('PolicyId')]
        [object]
        $Policy
    )

    process {
        $PolicyId = $Policy | Resolve-TeamViewerPolicyId
        $ResourceUri = "$(Get-TeamViewerAPIUri)/teamviewerpolicies/$PolicyId"

        if ($PSCmdlet.ShouldProcess($PolicyId, 'Delete policy')) {
            Invoke-TeamViewerRestMethod `
                -APIToken $APIToken `
                -Uri $ResourceUri `
                -Method Delete `
                -WriteErrorTo $PSCmdlet | `
                Out-Null
        }
    }
}
