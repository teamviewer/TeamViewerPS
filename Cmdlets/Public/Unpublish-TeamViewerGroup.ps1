function Unpublish-TeamViewerGroup {
    [CmdletBinding(SupportsShouldProcess = $true)]

    [OutputType([void])]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $APIToken,

        [Parameter(Mandatory = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerGroupId } )]
        [Alias('GroupId')]
        [object]
        $Group,

        [Parameter(Mandatory = $true)]
        [Alias('UserId')]
        [object[]]
        $User
    )

    $GroupId = $Group | Resolve-TeamViewerGroupId
    $UserIds = $User | Resolve-TeamViewerUserId
    $ResourceUri = "$(Get-TeamViewerAPIUri)/groups/$GroupId/unshare_group"
    $Body = @{users = @($UserIds) }

    if ($PSCmdlet.ShouldProcess($UserIds, 'Remove group share')) {
        Invoke-TeamViewerRestMethod `
            -APIToken $APIToken `
            -Uri $ResourceUri `
            -Method Post `
            -ContentType 'application/json; charset=utf-8' `
            -Body ([System.Text.Encoding]::UTF8.GetBytes(($Body | ConvertTo-Json))) `
            -WriteErrorTo $PSCmdlet | `
            Out-Null
    }
}
