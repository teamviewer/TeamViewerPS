function ConvertTo-TeamViewerRole {
    param(
        [Parameter(ValueFromPipeline)]
        [object]
        $InputObject
    )

    process {
        $Properties = @{
            RoleName = $InputObject.Name
            RoleID   = $InputObject.Id
        }

        if ($InputObject.Permissions) {
            foreach ($permission in $InputObject.Permissions.PSObject.Properties) {
                $Properties[$permission.Name] = $permission.Value
            }
        }

        $Result = New-Object -TypeName PSObject -Property $Properties
        $Result.PSObject.TypeNames.Insert(0, 'TeamViewerPS.Role')
        $Result | Add-Member -MemberType ScriptMethod -Name 'ToString' -Force -Value {
            "[$($this.RoleName)] [$($this.RoleID)] $($this.Permissions))"
        }

        Write-Output $Result
    }
}

