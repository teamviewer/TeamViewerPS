function Remove-TeamViewerPolicy {
    [CmdletBinding(SupportsShouldProcess = $true, DefaultParameterSetName = 'ByParameters')]

    [OutputType([void])]

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

    process {
        $PolicyId = $Policy | Resolve-TeamViewerPolicyId
        $ResourceUri = "$(Get-TeamViewerApiUri)/teamviewerpolicies/$PolicyId"

        if ($PSCmdlet.ShouldProcess($PolicyId, 'Delete policy')) {
            Invoke-TeamViewerRestMethod `
                -ApiToken $ApiToken `
                -Uri $ResourceUri `
                -Method Delete `
                -WriteErrorTo $PSCmdlet | `
                Out-Null
        }
    }
}
