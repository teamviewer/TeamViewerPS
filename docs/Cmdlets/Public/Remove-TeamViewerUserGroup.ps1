function Remove-TeamViewerUserGroup {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerUserGroupId } )]
        [Alias("UserGroupId")]
        [Alias("Id")]
        [object]
        $UserGroup
    )

    Begin {
        $id = $UserGroup | Resolve-TeamViewerUserGroupId
        $resourceUri = "$(Get-TeamViewerApiUri)/usergroups/$id"
    }

    Process {
        if ($PSCmdlet.ShouldProcess($UserGroup.ToString(), "Remove user group")) {
            Invoke-TeamViewerRestMethod `
                -ApiToken $ApiToken `
                -Uri $resourceUri `
                -Method Delete `
                -WriteErrorTo $PSCmdlet `
                -ErrorAction Stop | `
                Out-Null
        }
    }
}
