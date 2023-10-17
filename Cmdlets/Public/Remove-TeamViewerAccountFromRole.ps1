function Remove-TeamViewerAccountFromRole {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerUserRoleId } )]
        [Alias('UserRole')]
        [object]
        $UserRoleId,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [Alias('Id', 'UserIds')]
        [string[]]
        $Accounts
    )

    Begin {
        $id = $UserRoleId | Resolve-TeamViewerUserRoleId
        $null = $ApiToken
        $resourceUri = "$(Get-TeamViewerApiUri)/userroles/unassign/account"
        $AccountsToRemove = @()
        $body = @{
            UserIds    = @()
            UserRoleId = $id
        }
        function Invoke-TeamViewerRestMethodInternal {
            $result = Invoke-TeamViewerRestMethod `
                -ApiToken $ApiToken `
                -Uri $resourceUri `
                -Method Post `
                -ContentType 'application/json; charset=utf-8' `
                -Body ([System.Text.Encoding]::UTF8.GetBytes(($body | ConvertTo-Json))) `
                -WriteErrorTo $PSCmdlet `
                -ErrorAction Stop
            Write-Output ($result)
        }

    }

    Process {
        if ($PSCmdlet.ShouldProcess($Accounts, 'Unassign Account from Role')) {
            if (($Accounts -notmatch 'u[0-9]+') -and ($Accounts -match '[0-9]+')) {
                $Accounts = $Accounts | ForEach-Object { $_.Insert(0, 'u') }
            }
            foreach ($Account in $Accounts) {
                $AccountsToRemove += $Account
                $body.UserIds = @($AccountsToRemove)
            }
        }
        if ($AccountsToRemove.Length -eq 100) {
            Invoke-TeamViewerRestMethodInternal
            $AccountsToRemove = @()
        }
    }
    End {
        if ($AccountsToRemove.Length -gt 0) {
            Invoke-TeamViewerRestMethodInternal
        }
    }
}
