function Set-TeamViewerUserGroup {
    [CmdletBinding(SupportsShouldProcess = $true)]

    [OutputType('TeamViewerPS.UserGroup')]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $APIToken,

        [Parameter(Mandatory = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerUserGroupId } )]
        [Alias('Id', 'UserGroupId')]
        [object]
        $UserGroup,

        [Parameter(Mandatory = $true)]
        [string]
        $Name
    )

    begin {
        $UserGroup_Id = $UserGroup | Resolve-TeamViewerUserGroupId

        $Resource_Uri = "$(Get-TeamViewerAPIUri)/usergroups/$UserGroup_Id"
        $Body = @{ name = $Name }
    }

    process {
        if ($PSCmdlet.ShouldProcess($UserGroup_Id, 'Change user group')) {
            $Response = Invoke-TeamViewerRestMethod `
                -APIToken $APIToken `
                -Uri $Resource_Uri `
                -Method Put `
                -ContentType 'application/json; charset=utf-8' `
                -Body ([System.Text.Encoding]::UTF8.GetBytes(($Body | ConvertTo-Json))) `
                -WriteErrorTo $PSCmdlet `
                -ErrorAction Stop

            Write-Output ($Response | ConvertTo-TeamViewerUserGroup)
        }
    }
}
