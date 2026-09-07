function Unpublish-TeamViewerGroup {
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
        [Alias('UserId', 'UserIds')]
        [object[]]
        $User
    )

    $Group_Id = $Group | Resolve-TeamViewerGroupId
    $User_Ids = $User | Resolve-TeamViewerUserId

    $Resource_Uri = "$(Get-TeamViewerAPIUri)/groups/$Group_Id/unshare_group"
    $Body = @{users = @($User_Ids) }

    if ($PSCmdlet.ShouldProcess($User_Ids, 'Unpublish group')) {
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
