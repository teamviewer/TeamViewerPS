function Set-TeamViewerUserGroup {
    [CmdletBinding(SupportsShouldProcess = $true)]

    [OutputType('TeamViewerPS.UserGroup')]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $APIToken,

        [Parameter(Mandatory = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerUserGroupId } )]
        [Alias('UserGroupId')]
        [Alias('Id')]
        [object]
        $UserGroup,

        [Parameter(Mandatory = $true)]
        [Alias('UserGroupName')]
        [string]
        $Name
    )

    begin {
        $Id = $UserGroup | Resolve-TeamViewerUserGroupId
        $ResourceUri = "$(Get-TeamViewerAPIUri)/usergroups/$id"
        $Body = @{ name = $Name }
    }

    process {
        if ($PSCmdlet.ShouldProcess($UserGroup.ToString(), 'Change user group')) {
            $Response = Invoke-TeamViewerRestMethod `
                -APIToken $APIToken `
                -Uri $ResourceUri `
                -Method Put `
                -ContentType 'application/json; charset=utf-8' `
                -Body ([System.Text.Encoding]::UTF8.GetBytes(($Body | ConvertTo-Json))) `
                -WriteErrorTo $PSCmdlet `
                -ErrorAction Stop

            Write-Output ($Response | ConvertTo-TeamViewerUserGroup)
        }
    }
}
