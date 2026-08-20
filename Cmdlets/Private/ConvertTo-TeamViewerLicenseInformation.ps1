function ConvertTo-TeamViewerLicenseInformation {
    param(
        [Parameter(ValueFromPipeline)]
        [object]
        $InputObject
    )

    process {
        $Properties = @{
            Id               = [guid]$InputObject.licenseId
            Name             = $InputObject.licenseName
            DisplayName      = $InputObject.displayName
            Details          = $InputObject.details
            Type             = $InputObject.type
            Version          = [int]$InputObject.version
            IsActive         = [bool]$InputObject.isActive
            AssignedUsers    = [int]$InputObject.assignedUsers
            ManagedDevices   = [int]$InputObject.managedDevices
            AiCredits        = [int]$InputObject.aiCredits
            NumberOfChannels = [int]$InputObject.numberOfChannels
            MaxAssignments   = [int]$InputObject.maxAssignments
            TotalTechnicians = [int]$InputObject.totalTechnicians
        }

        $Result = New-Object -TypeName PSObject -Property $Properties
        $Result.PSObject.TypeNames.Insert(0, 'TeamViewerPS.LicenseInformation')

        Write-Output $Result
    }
}
