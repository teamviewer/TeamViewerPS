function Remove-TeamViewerManagedGroup {
    [CmdletBinding(SupportsShouldProcess = $true)]

    [OutputType([void])]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerManagedGroupId } )]
        [Alias('GroupId')]
        [Alias('Id')]
        [object]
        $Group
    )

    process {
        $GroupId = $Group | Resolve-TeamViewerManagedGroupId
        $ResourceUri = "$(Get-TeamViewerApiUri)/managed/groups/$GroupId"

        if ($PSCmdlet.ShouldProcess($GroupId, 'Remove managed group')) {
            Invoke-TeamViewerRestMethod `
                -ApiToken $ApiToken `
                -Uri $ResourceUri `
                -Method Delete `
                -WriteErrorTo $PSCmdlet | `
                Out-Null
        }
    }
}
