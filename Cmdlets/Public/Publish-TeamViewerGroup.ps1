function Publish-TeamViewerGroup {
    [CmdletBinding(SupportsShouldProcess = $true)]

    [OutputType([void])]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $APIToken,

        [Parameter(Mandatory = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerGroupId } )]
        [Alias('Id', 'GroupId')]
        [object]
        $Group,

        [Parameter(Mandatory = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerUserId } )]
        [Alias('UserId', 'UserIds')]
        [object[]]
        $User,

        [Parameter()]
        [ValidateSet('read', 'readwrite')]
        $Permissions = 'read'
    )

    $null = $Permissions # https://github.com/PowerShell/PSScriptAnalyzer/issues/1472

    $GroupId = $Group | Resolve-TeamViewerGroupId
    $UserIds = $User | Resolve-TeamViewerUserId
    $Resource_Uri = "$(Get-TeamViewerAPIUri)/groups/$GroupId/share_group"
    $Body = @{
        users = @($UserIds | ForEach-Object { @{
                    userid      = $_
                    permissions = $Permissions
                } })
    }

    if ($PSCmdlet.ShouldProcess($UserIds, 'Add group share')) {
        Invoke-TeamViewerRestMethod `
            -APIToken $APIToken `
            -Uri $Resource_Uri `
            -Method Post `
            -ContentType 'application/json; charset=utf-8' `
            -Body ([System.Text.Encoding]::UTF8.GetBytes(($Body | ConvertTo-Json))) `
            -WriteErrorTo $PSCmdlet | `
            Out-Null
    }
}
