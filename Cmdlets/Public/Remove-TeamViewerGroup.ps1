function Remove-TeamViewerGroup {
    [CmdletBinding(SupportsShouldProcess = $true)]

    [OutputType([void])]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $APIToken,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerGroupId } )]
        [Alias('GroupId')]
        [Alias('Id')]
        [object]
        $Group
    )

    process {
        $GroupId = $Group | Resolve-TeamViewerGroupId
        $Resource_Uri = "$(Get-TeamViewerAPIUri)/groups/$GroupId"

        if ($PSCmdlet.ShouldProcess($GroupId, 'Remove group')) {
            Invoke-TeamViewerRestMethod `
                -APIToken $APIToken `
                -Uri $Resource_Uri `
                -Method Delete `
                -WriteErrorTo $PSCmdlet | `
                Out-Null
        }
    }
}
