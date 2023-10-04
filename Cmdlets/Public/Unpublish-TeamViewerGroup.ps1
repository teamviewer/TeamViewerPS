function Unpublish-TeamViewerGroup {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerGroupId } )]
        [Alias("GroupId")]
        [object]
        $Group,

        [Parameter(Mandatory = $true)]
        [Alias("UserId")]
        [object[]]
        $User
    )

    $groupId = $Group | Resolve-TeamViewerGroupId
    $userIds = $User | Resolve-TeamViewerUserId
    $resourceUri = "$(Get-TeamViewerApiUri)/groups/$groupId/unshare_group"
    $body = @{users = @($userIds) }

    if ($PSCmdlet.ShouldProcess($userids, "Remove group share")) {
        Invoke-TeamViewerRestMethod `
            -ApiToken $ApiToken `
            -Uri $resourceUri `
            -Method Post `
            -ContentType "application/json; charset=utf-8" `
            -Body ([System.Text.Encoding]::UTF8.GetBytes(($body | ConvertTo-Json))) `
            -WriteErrorTo $PSCmdlet | `
            Out-Null
    }
}
