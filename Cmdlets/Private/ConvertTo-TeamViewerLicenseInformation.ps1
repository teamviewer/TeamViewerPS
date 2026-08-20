function ConvertTo-TeamViewerLicenseInformation {
    param(
        [Parameter(ValueFromPipeline)]
        [object]
        $InputObject
    )

    process {
        $Properties = @{
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

        $Result = New-Object -TypeName PSObject -Property $Properties
        $Result.PSObject.TypeNames.Insert(0, 'TeamViewerPS.LicenseInformation')
        $Result | Add-Member -MemberType ScriptMethod -Name 'ToString' -Force -Value {
            "$($this.LicenseName)"
        }

        Write-Output $Result
    }
}
