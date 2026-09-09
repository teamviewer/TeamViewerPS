function ConvertTo-TeamViewerAddressBook {
    param(
        [Parameter(ValueFromPipeline)]
        [object]
        $InputObject
    )

    process {
        $Result = $InputObject.PSObject.Copy()
        $Users = if ($InputObject.users) {
            @($InputObject.Users | ConvertTo-TeamViewerAddressBookUser)
        }
        else {
            @()
        }

        $Result | Add-Member -MemberType NoteProperty -Name users -Value $Users -Force

        $Enabled = if ($InputObject.PSObject.Properties['state']) {
            $InputObject.State
        }
        else {
            $InputObject.companyAddressBookSettings.addressBookAvailable
        }

        $Result | Add-Member -MemberType NoteProperty -Name Enabled -Value $Enabled -Force
        $Result.PSObject.TypeNames.Insert(0, 'TeamViewerPS.AddressBook')

        Write-Output $Result
    }
}
