function Remove-TeamViewerGroup {
    [CmdletBinding(SupportsShouldProcess = $true)]

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
        $Group
    )

    process {
        $GroupId = $Group | Resolve-TeamViewerGroupId
        $ResourceUri = "$(Get-TeamViewerApiUri)/groups/$GroupId"

        if ($PSCmdlet.ShouldProcess($GroupId, 'Remove group')) {
            Invoke-TeamViewerRestMethod `
                -ApiToken $ApiToken `
                -Uri $ResourceUri `
                -Method Delete `
                -WriteErrorTo $PSCmdlet | `
                Out-Null
        }
    }
}
