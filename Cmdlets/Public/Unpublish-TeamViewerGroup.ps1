function Unpublish-TeamViewerGroup {
    [CmdletBinding(SupportsShouldProcess = $true)]

    [OutputType([void])]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

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
    $ResourceUri = "$(Get-TeamViewerApiUri)/groups/$GroupId/unshare_group"
    $Body = @{users = @($UserIds) }

    if ($PSCmdlet.ShouldProcess($UserIds, 'Remove group share')) {
        Invoke-TeamViewerRestMethod `
            -ApiToken $ApiToken `
            -Uri $ResourceUri `
            -Method Post `
            -ContentType 'application/json; charset=utf-8' `
            -Body ([System.Text.Encoding]::UTF8.GetBytes(($Body | ConvertTo-Json))) `
            -WriteErrorTo $PSCmdlet | `
            Out-Null
    }
}
