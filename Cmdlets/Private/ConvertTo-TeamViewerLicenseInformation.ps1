function ConvertTo-TeamViewerLicenseInformation {
    param(
        [Parameter(ValueFromPipeline)]
        [PSObject]
        $InputObject
    )

    begin {
        $properties = @{
            LicenseName      = $InputObject.licenseName
            Version          = [int]$InputObject.version
            Type             = $InputObject.type
            LicenseId        = [guid]$InputObject.licenseId
            IsActive         = [bool]$InputObject.isActive
            AiCredits        = [int]$InputObject.aiCredits
            ManagedDevices   = [int]$InputObject.managedDevices
            AssignedUsers    = [int]$InputObject.assignedUsers
            DisplayName      = $InputObject.displayName
            Details          = $InputObject.details
            NumberOfChannels = [int]$InputObject.numberOfChannels
            MaxAssignments   = [int]$InputObject.maxAssignments
            TotalTechnicians = [int]$InputObject.totalTechnicians
        }
    }

    process {
        $result = New-Object -TypeName PSObject -Property $properties
        $result.PSObject.TypeNames.Insert(0, 'TeamViewerPS.LicenseInformation')
        $result | Add-Member -MemberType ScriptMethod -Name 'ToString' -Force -Value {
            "$($this.LicenseName)"
        }

        $result
    }
}
