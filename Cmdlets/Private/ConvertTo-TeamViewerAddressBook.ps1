function ConvertTo-TeamViewerAddressBook {
    param(
        [Parameter(ValueFromPipeline)]
        [object]
        $InputObject
    )

    process {
        $Result = $InputObject.PSObject.Copy()
        $Users = if ($InputObject.users) {
            @($InputObject.users | ConvertTo-TeamViewerAddressBookUser) 
        }
        else {
            @() 
        }
        $Result | Add-Member -MemberType NoteProperty -Name users -Value $Users -Force
        $Result | Add-Member -MemberType NoteProperty -Name Enabled -Value $InputObject.companyAddressBookSettings.addressBookAvailable -Force
        $Result.PSObject.TypeNames.Insert(0, 'TeamViewerPS.AddressBook')

        Write-Output $Result
    }
}
