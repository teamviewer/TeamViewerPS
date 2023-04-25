function Remove-TeamViewerUser {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerUserId } )]
        [Alias("UserId")]
        [Alias("Id")]
        [object]
        $User,

        [Parameter()]
        [switch]
        $Permanent
    )
    Process {
        $userId = $User | Resolve-TeamViewerUserId
        $resourceUri = "$(Get-TeamViewerApiUri)/users/$userId"

        if ($Permanent) {
            $resourceUri += '?isPermanentDelete=true'
        }

        if ($PSCmdlet.ShouldProcess($userId, "Remove user")) {
            Invoke-TeamViewerRestMethod `
                -ApiToken $ApiToken `
                -Uri $resourceUri `
                -Method Delete `
                -WriteErrorTo $PSCmdlet | `
                Out-Null
        }
    }
}
