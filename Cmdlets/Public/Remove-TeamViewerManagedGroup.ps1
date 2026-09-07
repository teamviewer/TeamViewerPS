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
        [Alias('ManagedGroupId', 'ManagedGroup')]
        [object]
        $Group
    )

    process {
        $GroupId = $Group | Resolve-TeamViewerManagedGroupId
        $Resource_Uri = "$(Get-TeamViewerAPIUri)/managed/groups/$GroupId"

        if ($PSCmdlet.ShouldProcess($GroupId, 'Remove managed group')) {
            Invoke-TeamViewerRestMethod `
                -APIToken $APIToken `
                -Uri $Resource_Uri `
                -Method Delete `
                -WriteErrorTo $PSCmdlet | `
                Out-Null
        }
    }
}
