function Publish-TeamViewerGroup {
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
        [ValidateScript( { $_ | Resolve-TeamViewerUserId } )]
        [Alias("UserId")]
        [object[]]
        $User,

        [Parameter()]
        [ValidateSet("read", "readwrite")]
        $Permissions = "read"
    )

    # Warning suppresion doesn't seem to work.
    # See https://github.com/PowerShell/PSScriptAnalyzer/issues/1472
    $null = $Permissions

    $groupId = $Group | Resolve-TeamViewerGroupId
    $userIds = $User | Resolve-TeamViewerUserId
    $resourceUri = "$(Get-TeamViewerApiUri)/groups/$groupId/share_group"
    $body = @{
        users = @($userIds | ForEach-Object { @{
                    userid      = $_
                    permissions = $Permissions
                } })
    }

    if ($PSCmdlet.ShouldProcess($userids, "Add group share")) {
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
