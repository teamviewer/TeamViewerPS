function ConvertTo-TeamViewerRole {
    param(
        [Parameter(ValueFromPipeline)]
        [object]
        $InputObject
    )

    process {
        $Properties = @{
            Id   = $InputObject.Id
            Name = $InputObject.Name
        }

        if ($InputObject.Permissions) {
            foreach ($permission in $InputObject.Permissions.PSObject.Properties) {
                $Properties[$permission.Name] = $permission.Value
            }
        }

        $Result = New-Object -TypeName PSObject -Property $Properties
        $Result.PSObject.TypeNames.Insert(0, 'TeamViewerPS.Role')

        Write-Output $Result
    }
}
