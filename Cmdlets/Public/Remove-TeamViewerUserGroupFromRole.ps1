function Remove-TeamViewerUserGroupFromRole {
    [CmdletBinding(SupportsShouldProcess = $true)]

    [OutputType([pscustomobject])]

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
        $null = $APIToken # https://github.com/PowerShell/PSScriptAnalyzer/issues/1472
        $Resource_Uri = "$(Get-TeamViewerAPIUri)/userroles/unassign/usergroup"
        $Body = @{
            UserGroupId = $UserGroup
        }
    }


    process {
        if ($PSCmdlet.ShouldProcess($UserGroupId, 'Unassign User Group from user role')) {
            $Result = Invoke-TeamViewerRestMethod `
                -APIToken $APIToken `
                -Uri $Resource_Uri `
                -Method Post `
                -ContentType 'application/json; charset=utf-8' `
                -Body ([System.Text.Encoding]::UTF8.GetBytes(($Body | ConvertTo-Json))) `
                -WriteErrorTo $PSCmdlet `
                -ErrorAction Stop
            Write-Output ($Result)
        }
    }
}
