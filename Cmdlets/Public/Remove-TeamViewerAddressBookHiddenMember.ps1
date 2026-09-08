function Remove-TeamViewerAddressBookHiddenMember {
    [CmdletBinding(SupportsShouldProcess = $true, DefaultParameterSetName = 'ById')]

    [OutputType([void])]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $APIToken,

        [Parameter(Mandatory = $true, ParameterSetName = 'ById', ValueFromPipeline = $true)]
        [Alias('Id', 'UserId', 'Email', 'Emailaddress')]
        [string[]]
        $User
    )

    begin {
        $Resource_Uri = "$(Get-TeamViewerAPIUri)/companyaddressbook/hiddenmembers"
        $Users_ToRemove = @()
        $null = $APIToken # https://github.com/PowerShell/PSScriptAnalyzer/issues/1472
    }

    process {
        if ($PSCmdlet.ShouldProcess($User, 'Remove from address book hidden members')) {
            $Users_ToRemove += $User
        }

        if ($Users_ToRemove.Length -eq 100) {
            Invoke-TeamViewerJsonRestMethod `
                -APIToken $APIToken `
                -Uri $Resource_Uri `
                -Method Delete `
                -Body (@{ accountIds = @($Users_ToRemove) } | ConvertTo-Json) `
                -CallerCmdlet $PSCmdlet | Out-Null
            $Users_ToRemove = @()
        }
    }

    end {
        if ($Users_ToRemove.Length -gt 0) {
            Invoke-TeamViewerJsonRestMethod `
                -APIToken $APIToken `
                -Uri $Resource_Uri `
                -Method Delete `
                -Body (@{ accountIds = @($Users_ToRemove) } | ConvertTo-Json) `
                -CallerCmdlet $PSCmdlet | Out-Null
        }
    }
}
