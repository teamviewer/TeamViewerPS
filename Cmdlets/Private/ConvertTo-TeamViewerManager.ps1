function ConvertTo-TeamViewerManager {
    param(
        [Parameter(ValueFromPipeline)]
        [object]
        $InputObject,

        [Parameter(Mandatory = $true, ParameterSetName = 'GroupManager')]
        [guid]
        $GroupId,

        [Parameter(Mandatory = $true, ParameterSetName = 'DeviceManager')]
        [guid]
        $DeviceId
    )

    process {
        $Properties = @{
            Id           = [guid]$InputObject.id
            Name         = $InputObject.name
            Manager_Type = $InputObject.type
            Permissions  = $InputObject.permissions
        }

        switch ($InputObject.type) {
            'account' {
                $Properties.User_Id = $InputObject.accountId
            }
            'company' {
                $Properties.Company_Id = $InputObject.companyId
            }
        }

        switch ($PsCmdlet.ParameterSetName) {
            'GroupManager' {
                $Properties.Group_Id = $GroupId
            }
            'DeviceManager' {
                $Properties.Device_Id = $DeviceId
            }
        }

        $Result = New-Object -TypeName PSObject -Property $Properties
        $Result.PSObject.TypeNames.Insert(0, 'TeamViewerPS.Manager')

        Write-Output $Result
    }
}
