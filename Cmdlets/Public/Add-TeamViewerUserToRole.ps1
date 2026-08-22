function Add-TeamViewerUserToRole {
    [CmdletBinding(SupportsShouldProcess = $true)]

    [OutputType([pscustomobject])]

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

    begin {
        $Id = $RoleId | Resolve-TeamViewerRoleId
        $null = $ApiToken
        $ResourceUri = "$(Get-TeamViewerApiUri)/userroles/assign/account"
        $AccountsToAdd = @()
        $Body = @{
            UserIds    = @()
            UserRoleId = $id
        }

        function Invoke-TeamViewerRestMethodInternal {
            $Result = Invoke-TeamViewerRestMethod `
                -ApiToken $ApiToken `
                -Uri $ResourceUri `
                -Method Post `
                -ContentType 'application/json; charset=utf-8' `
                -Body ([System.Text.Encoding]::UTF8.GetBytes(($Body | ConvertTo-Json))) `
                -WriteErrorTo $PSCmdlet `
                -ErrorAction Stop

            Write-Output ($Result)
        }
    }


    process {
        if ($PSCmdlet.ShouldProcess($Accounts, 'Assign Account to Role')) {
            if (($Accounts -notmatch 'u[0-9]+') -and ($Accounts -match '[0-9]+')) {
                $Accounts = $Accounts | ForEach-Object { $_.Insert(0, 'u') }
            }
            foreach ($Account in $Accounts) {
                $AccountsToAdd += $Account
                $Body.UserIds = @($AccountsToAdd)
            }
        }
        if ($AccountsToAdd.Length -eq 100) {
            Invoke-TeamViewerRestMethodInternal
            $AccountsToAdd = @()
        }
    }
    end {
        if ($AccountsToAdd.Length -gt 0) {
            Invoke-TeamViewerRestMethodInternal
        }
    }
}

