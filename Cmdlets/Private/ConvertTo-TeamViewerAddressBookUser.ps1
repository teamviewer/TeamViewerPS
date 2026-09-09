function ConvertTo-TeamViewerAddressBookUser {
    param(
        [Parameter(ValueFromPipeline)]
        [object]
        $InputObject
    )

    process {
        $AccountId = $InputObject.accountId
        $Email = $InputObject.email
        $Name = $InputObject.name

        if ($InputObject -is [System.Collections.IDictionary]) {
            $AccountId = $InputObject['accountId']
            $Email = $InputObject['email']
            $Name = $InputObject['name']
        }

        $Properties = @{
            UserId    = $AccountId
            AccountId = $AccountId
            Email     = $Email
        }

        if ($null -ne $Name) {
            $Properties.Name = $Name
        }

        $Result = New-Object -TypeName PSObject -Property $Properties
        $Result.PSObject.TypeNames.Insert(0, 'TeamViewerPS.AddressBookUser')

        Write-Output $Result
    }
}
