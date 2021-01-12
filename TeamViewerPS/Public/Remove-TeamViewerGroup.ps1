function Remove-TeamViewerGroup {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerGroupId } )]
        [Alias("GroupId")]
        [Alias("Id")]
        [object]
        $Group
    )
    Process {
        $groupId = $Group | Resolve-TeamViewerGroupId
        $resourceUri = "$(Get-TeamViewerApiUri)/groups/$groupId"

        if ($PSCmdlet.ShouldProcess($groupId, "Remove group")) {
            Invoke-TeamViewerRestMethod `
                -ApiToken $ApiToken `
                -Uri $resourceUri `
                -Method Delete `
                -WriteErrorTo $PSCmdlet | `
                Out-Null
        }
    }
}
