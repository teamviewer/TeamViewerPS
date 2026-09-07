function Remove-TeamViewerUserFromRole {
    [CmdletBinding(SupportsShouldProcess = $true)]

    [OutputType([pscustomobject])]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $APIToken,

        [Parameter(Mandatory = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerRoleId } )]
        [Alias('Id', 'RoleId')]
        [object]
        $Role,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [Alias('UserId', 'UserIds')]
        [string[]]
        $User
    )

    begin {
        $Id = $Role | Resolve-TeamViewerRoleId
        $null = $APIToken # https://github.com/PowerShell/PSScriptAnalyzer/issues/1472
        $Resource_Uri = "$(Get-TeamViewerAPIUri)/userroles/unassign/account"
        $AccountsToRemove = @()
        $Body = @{
            UserIds    = @()
            UserRoleId = $id
        }
    }

    process {
        if ($PSCmdlet.ShouldProcess($User, 'Unassign Account from user role')) {
            if (($User -notmatch 'u[0-9]+') -and ($User -match '[0-9]+')) {
                $User = $User | ForEach-Object { $_.Insert(0, 'u') }
            }
            foreach ($Account in $User) {
                $AccountsToRemove += $Account
                $Body.UserIds = @($AccountsToRemove)
            }
        }

        if ($AccountsToRemove.Length -eq 100) {
            Write-Output (Invoke-TeamViewerJsonRestMethod `
                    -APIToken $APIToken `
                    -Uri $Resource_Uri `
                    -Method Post `
                    -Body ($Body | ConvertTo-Json) `
                    -CallerCmdlet $PSCmdlet)
            $AccountsToRemove = @()
        }
    }
    end {
        if ($AccountsToRemove.Length -gt 0) {
            Write-Output (Invoke-TeamViewerJsonRestMethod `
                    -APIToken $APIToken `
                    -Uri $Resource_Uri `
                    -Method Post `
                    -Body ($Body | ConvertTo-Json) `
                    -CallerCmdlet $PSCmdlet)
        }
    }
}
