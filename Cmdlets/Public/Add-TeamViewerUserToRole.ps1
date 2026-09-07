function Add-TeamViewerUserToRole {
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
        $Role_Id = $Role | Resolve-TeamViewerRoleId

        $null = $APIToken # https://github.com/PowerShell/PSScriptAnalyzer/issues/1472

        $Resource_Uri = "$(Get-TeamViewerAPIUri)/userroles/assign/account"
        $Users_ToAdd = @()
        $Body = @{
            UserIds    = @()
            UserRoleId = $Role_Id
        }
    }

    process {
        if ($PSCmdlet.ShouldProcess($User, 'Add user to role')) {
            if (($User -notmatch 'u[0-9]+') -and ($User -match '[0-9]+')) {
                $User = $User | ForEach-Object { $_.Insert(0, 'u') }
            }
            foreach ($Account in $User) {
                $Users_ToAdd += $Account
                $Body.UserIds = @($Users_ToAdd)
            }
        }
        if ($Users_ToAdd.Length -eq 100) {
            Write-Output (Invoke-TeamViewerJsonRestMethod `
                    -APIToken $APIToken `
                    -Uri $Resource_Uri `
                    -Method Post `
                    -Body ($Body | ConvertTo-Json) `
                    -CallerCmdlet $PSCmdlet)
            $Users_ToAdd = @()
        }
    }
    end {
        if ($Users_ToAdd.Length -gt 0) {
            Write-Output (Invoke-TeamViewerJsonRestMethod `
                    -APIToken $APIToken `
                    -Uri $Resource_Uri `
                    -Method Post `
                    -Body ($Body | ConvertTo-Json) `
                    -CallerCmdlet $PSCmdlet)
        }
    }
}
