function Add-TeamViewerUserToRole {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $ApiToken,

        [Parameter(Mandatory = $true)]
        [ValidateScript( { $_ | Resolve-TeamViewerRoleId } )]
        [Alias('Role')]
        [object]
        $RoleId,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [Alias('Id', 'UserIds')]
        [string[]]
        $Accounts
    )

    Begin {
        $id = $RoleId | Resolve-TeamViewerRoleId
        $null = $ApiToken
        $resourceUri = "$(Get-TeamViewerApiUri)/userroles/assign/account"
        $AccountsToAdd = @()
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
        if ($PSCmdlet.ShouldProcess($Accounts, 'Assign Account to Role')) {
            if (($Accounts -notmatch 'u[0-9]+') -and ($Accounts -match '[0-9]+')) {
                $Accounts = $Accounts | ForEach-Object { $_.Insert(0, 'u') }
            }
            foreach ($Account in $Accounts) {
                $AccountsToAdd += $Account
                $body.UserIds = @($AccountsToAdd)
            }
        }
        if ($AccountsToAdd.Length -eq 100) {
            Invoke-TeamViewerRestMethodInternal
            $AccountsToAdd = @()
        }
    }
    End {
        if ($AccountsToAdd.Length -gt 0) {
            Invoke-TeamViewerRestMethodInternal
        }
    }
}

