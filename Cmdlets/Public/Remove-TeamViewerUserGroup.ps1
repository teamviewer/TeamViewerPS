function Remove-TeamViewerUserGroup {
    [CmdletBinding(SupportsShouldProcess = $true)]

    [OutputType([void])]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $APIToken,

        [Parameter(Mandatory = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerUserGroupId } )]
        [Alias('UserGroupId')]
        [Alias('Id')]
        [object]
        $UserGroup
    )

    begin {
        $Id = $UserGroup | Resolve-TeamViewerUserGroupId
        $ResourceUri = "$(Get-TeamViewerAPIUri)/usergroups/$id"
    }

    process {
        if ($PSCmdlet.ShouldProcess($UserGroup.ToString(), 'Remove user group')) {
            Invoke-TeamViewerRestMethod `
                -APIToken $APIToken `
                -Uri $ResourceUri `
                -Method Delete `
                -WriteErrorTo $PSCmdlet `
                -ErrorAction Stop | `
                Out-Null
        }
    }
}
