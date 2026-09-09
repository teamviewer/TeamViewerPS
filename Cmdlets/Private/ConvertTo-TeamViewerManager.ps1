function ConvertTo-TeamViewerManager {
    param(
        [Parameter(ValueFromPipeline)]
        [object]
        $InputObject,

        [Parameter(Mandatory = $true, ParameterSetName = 'GroupManager')]
        [guid]
        $Group,

        [Parameter(Mandatory = $true, ParameterSetName = 'DeviceManager')]
        [guid]
        $Device
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
                $Properties.UserId = $InputObject.accountId
            }
            'company' {
                $Properties.CompanyId = $InputObject.companyId
            }
        }

        switch ($PsCmdlet.ParameterSetName) {
            'GroupManager' {
                $Properties.GroupId = $Group
            }
            'DeviceManager' {
                $Properties.DeviceId = $Device
            }
        }

        $Result = New-Object -TypeName PSObject -Property $Properties
        $Result.PSObject.TypeNames.Insert(0, 'TeamViewerPS.Manager')

        Write-Output $Result
    }
}
