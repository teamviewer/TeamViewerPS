function Add-TeamViewerAddressBookHiddenMember {
    [CmdletBinding(SupportsShouldProcess = $true)]

    [OutputType([void])]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $APIToken,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [Alias('Id', 'UserId', 'Emailaddress')]
        [string[]]
        $User
    )

    begin {
        $Resource_Uri = "$(Get-TeamViewerAPIUri)/companyaddressbook/hiddenmembers"
        $Users_ToAdd = @()
        $null = $APIToken # https://github.com/PowerShell/PSScriptAnalyzer/issues/1472
    }

    process {
        if ($PSCmdlet.ShouldProcess($User, 'Add to address book hidden members')) {
            $Users_ToAdd += $User
        }

        if ($Users_ToAdd.Length -eq 100) {
            Invoke-TeamViewerJsonRestMethod `
                -APIToken $APIToken `
                -Uri $Resource_Uri `
                -Method Post `
                -Body (@{ accountIds = @($Users_ToAdd) } | ConvertTo-Json) `
                -CallerCmdlet $PSCmdlet | Out-Null
            $Users_ToAdd = @()
        }
    }

    end {
        if ($Users_ToAdd.Length -gt 0) {
            Invoke-TeamViewerJsonRestMethod `
                -APIToken $APIToken `
                -Uri $Resource_Uri `
                -Method Post `
                -Body (@{ accountIds = @($Users_ToAdd) } | ConvertTo-Json) `
                -CallerCmdlet $PSCmdlet | Out-Null
        }
    }
}
