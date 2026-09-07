function Remove-TeamViewerUserGroup {
    [CmdletBinding(SupportsShouldProcess = $true)]

    [OutputType([void])]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $APIToken,

        [Parameter(Mandatory = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerUserGroupId } )]
        [Alias('Id', 'UserGroupId')]
        [object]
        $UserGroup
    )

    begin {
        $UserGroup_Id = $UserGroup | Resolve-TeamViewerUserGroupId

        $Resource_Uri = "$(Get-TeamViewerAPIUri)/usergroups/$UserGroup_Id"
    }

    process {
        if ($PSCmdlet.ShouldProcess($UserGroup_Id, 'Remove user group')) {
            Invoke-TeamViewerRestMethod `
                -APIToken $APIToken `
                -Uri $Resource_Uri `
                -Method Delete `
                -WriteErrorTo $PSCmdlet `
                -ErrorAction Stop | `
                Out-Null
        }
    }
}
