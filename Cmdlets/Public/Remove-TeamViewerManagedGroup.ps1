function Remove-TeamViewerManagedGroup {
    [CmdletBinding(SupportsShouldProcess = $true)]

    [OutputType([void])]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $APIToken,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerManagedGroupId } )]
        [Alias('GroupId')]
        [Alias('Id')]
        [object]
        $Group
    )

    process {
        $GroupId = $Group | Resolve-TeamViewerManagedGroupId
        $ResourceUri = "$(Get-TeamViewerAPIUri)/managed/groups/$GroupId"

        if ($PSCmdlet.ShouldProcess($GroupId, 'Remove managed group')) {
            Invoke-TeamViewerRestMethod `
                -APIToken $APIToken `
                -Uri $ResourceUri `
                -Method Delete `
                -WriteErrorTo $PSCmdlet | `
                Out-Null
        }
    }
}
