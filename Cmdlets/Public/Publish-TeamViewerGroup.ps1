function Publish-TeamViewerGroup {
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
        [ValidateScript( { $_ | Resolve-TeamViewerUserId } )]
        [Alias('UserId')]
        [object[]]
        $User,

        [Parameter()]
        [ValidateSet('read', 'readwrite')]
        $Permissions = 'read'
    )

    # Warning suppresion doesn't seem to work.
    # See https://github.com/PowerShell/PSScriptAnalyzer/issues/1472
    $null = $Permissions

    $GroupId = $Group | Resolve-TeamViewerGroupId
    $UserIds = $User | Resolve-TeamViewerUserId
    $ResourceUri = "$(Get-TeamViewerApiUri)/groups/$GroupId/share_group"
    $Body = @{
        users = @($UserIds | ForEach-Object { @{
                    userid      = $_
                    permissions = $Permissions
                } })
    }

    if ($PSCmdlet.ShouldProcess($UserIds, 'Add group share')) {
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
