function Get-TeamViewerAddressBook {
    [CmdletBinding()]

    [OutputType('TeamViewerPS.AddressBook', 'TeamViewerPS.AddressBookUser')]

    param(
        [Parameter(Mandatory = $true)]
        [securestring]
        $APIToken
    )

    $Resource_Uri = "$(Get-TeamViewerAPIUri)/companyaddressbook"
    $Parameters = @{}

    do {
        $Response = Invoke-TeamViewerRestMethod `
            -APIToken $APIToken `
            -Uri $Resource_Uri `
            -Method Get `
            -Body $Parameters `
            -WriteErrorTo $PSCmdlet `
            -ErrorAction Stop

        Write-Output ($Response | ConvertTo-TeamViewerAddressBook)

        $Parameters.ct = $Response.continuation_token
    } while ($Parameters.ct)
}
