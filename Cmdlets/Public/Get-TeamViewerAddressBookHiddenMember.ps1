function Get-TeamViewerAddressBookHiddenMember {
    [CmdletBinding()]

    [OutputType([string[]])]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $APIToken
    )

    $Resource_Uri = "$(Get-TeamViewerAPIUri)/companyaddressbook/hiddenmembers"
    $Parameters = @{}

    do {
        $Response = Invoke-TeamViewerRestMethod `
            -APIToken $APIToken `
            -Uri $Resource_Uri `
            -Method Get `
            -Body $Parameters `
            -WriteErrorTo $PSCmdlet `
            -ErrorAction Stop

        # Output the hidden member IDs
        Write-Output $Response.accountIds

        $Parameters.ct = $Response.continuation_token
    } while ($Parameters.ct)
}
