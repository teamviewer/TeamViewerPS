function ConvertTo-TeamViewerManager {
    param(
        [Parameter(ValueFromPipeline)]
        [PSObject]
        $InputObject,

        [Parameter(Mandatory = $true, ParameterSetName = "GroupManager")]
        [guid]
        $GroupId,

        [Parameter(Mandatory = $true, ParameterSetName = "DeviceManager")]
        [guid]
        $DeviceId
    )
    process {
        $properties = @{
            Id          = [guid]$InputObject.id
            ManagerType = $InputObject.type
            Name        = $InputObject.name
            Permissions = $InputObject.permissions
        }

        switch ($InputObject.type) {
            'account' {
                $properties.AccountId = $InputObject.accountId
            }
            'company' {
                $properties.CompanyId = $InputObject.companyId
            }
        }

        switch ($PsCmdlet.ParameterSetName) {
            'GroupManager' {
                $properties.GroupId = $GroupId
            }
            'DeviceManager' {
                $properties.DeviceId = $DeviceId
            }
        }

        $result = New-Object -TypeName PSObject -Property $properties
        $result.PSObject.TypeNames.Insert(0, 'TeamViewerPS.Manager')
        Write-Output $result
    }
}
