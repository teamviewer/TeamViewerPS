function ConvertTo-TeamViewerAddressBookUser {
    param(
        [Parameter(ValueFromPipeline)]
        [object]
        $InputObject
    )

    process {
        $UserId = $InputObject.accountId
        $Email = $InputObject.email
        $Name = $InputObject.name

        if ($InputObject -is [System.Collections.IDictionary]) {
            $UserId = $InputObject['accountId']
            $Email = $InputObject['email']
            $Name = $InputObject['name']
        }

        $Output_Properties = @{
            UserId = $UserId
            Email  = $Email
        }

        if ($null -ne $Name) {
            $Output_Properties.Name = $Name
        }

        $Result = New-Object -TypeName PSObject -Property $Output_Properties
        $Result.PSObject.TypeNames.Insert(0, 'TeamViewerPS.AddressBookUser')

        Write-Output $Result
    }
}
