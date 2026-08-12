function ConvertTo-TeamViewerRole {
    param(
        [Parameter(ValueFromPipeline)]
        [PSObject]
        $InputObject
    )

    begin {
        $properties = @{
            RoleName = $InputObject.Name
            RoleID   = $InputObject.Id
        }

        if ($InputObject.Permissions) {
            foreach ($permission in $InputObject.Permissions.PSObject.Properties) {
                $properties[$permission.Name] = $permission.Value
            }
        }
    }

    process {
        $result = New-Object -TypeName PSObject -Property $properties
        $result.PSObject.TypeNames.Insert(0, 'TeamViewerPS.Role')
        $result | Add-Member -MemberType ScriptMethod -Name 'ToString' -Force -Value {
            "[$($this.RoleName)] [$($this.RoleID)] $($this.Permissions))"
        }

        $result
    }
}

