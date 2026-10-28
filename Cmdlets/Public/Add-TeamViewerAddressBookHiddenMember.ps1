function Add-TeamViewerAddressBookHiddenMember {
    [CmdletBinding(SupportsShouldProcess = $true)]

    [OutputType([void])]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $APIToken,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [Alias('Id', 'UserId', 'Email', 'Emailaddress')]
        [object[]]
        $User
    )

    begin {
        $Resource_Uri = "$(Get-TeamViewerAPIUri)/companyaddressbook/hiddenmembers"
        $Users_ToAdd = @()
        $Email_Cache = @{}
        $null = $APIToken # https://github.com/PowerShell/PSScriptAnalyzer/issues/1472
    }

    process {
        foreach ($Member in $User) {
            if (-not $PSCmdlet.ShouldProcess([string]$Member, 'Add to address book hidden members')) {
                continue
            }

            $Users_ToAdd += Resolve-TeamViewerAccountId -APIToken $APIToken -User $Member -EmailCache $Email_Cache

            if ($Users_ToAdd.Length -eq 100) {
                Invoke-TeamViewerJsonRestMethod `
                    -APIToken $APIToken `
                    -Uri $Resource_Uri `
                    -Method Post `
                    -Body (ConvertTo-Json -InputObject @($Users_ToAdd)) `
                    -CallerCmdlet $PSCmdlet | Out-Null
                $Users_ToAdd = @()
            }
        }
    }

    end {
        if ($Users_ToAdd.Length -gt 0) {
            Invoke-TeamViewerJsonRestMethod `
                -APIToken $APIToken `
                -Uri $Resource_Uri `
                -Method Post `
                -Body (ConvertTo-Json -InputObject @($Users_ToAdd)) `
                -CallerCmdlet $PSCmdlet | Out-Null
        }
    }
}
