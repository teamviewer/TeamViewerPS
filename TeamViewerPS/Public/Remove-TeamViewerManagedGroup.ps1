function Remove-TeamViewerManagedGroup {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerManagedGroupId } )]
        [Alias("GroupId")]
        [Alias("Id")]
        [object]
        $Group
    )
    Process {
        $groupId = $Group | Resolve-TeamViewerManagedGroupId
        $resourceUri = "$(Get-TeamViewerApiUri)/managed/groups/$groupId"

        if ($PSCmdlet.ShouldProcess($groupId, "Remove managed group")) {
            Invoke-TeamViewerRestMethod `
                -ApiToken $ApiToken `
                -Uri $resourceUri `
                -Method Delete `
                -WriteErrorTo $PSCmdlet | `
                Out-Null
        }
    }
}
