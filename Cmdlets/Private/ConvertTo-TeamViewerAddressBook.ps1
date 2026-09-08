function ConvertTo-TeamViewerAddressBook {
    param(
        [Parameter(ValueFromPipeline)]
        [object]
        $InputObject
    )

    process {
        $Result = $InputObject.PSObject.Copy()
        $Result.users = @($InputObject.users | ConvertTo-TeamViewerAddressBookUser)
        $Result | Add-Member -MemberType NoteProperty -Name Enabled -Value $InputObject.companyAddressBookSettings.addressBookAvailable -Force
        $Result.PSObject.TypeNames.Insert(0, 'TeamViewerPS.AddressBook')

        Write-Output $Result
    }
}
