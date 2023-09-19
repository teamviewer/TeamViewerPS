function ConvertTo-TeamViewerUserRole {
    param(
        [Parameter(ValueFromPipeline)]
        [PSObject]
        $InputObject
    )
    process {
        $properties = @{
            RoleName = $InputObject.Name
            RoleID   = $InputObject.Id
        }
        if ($InputObject.Permissions) {
            foreach ($permission in $InputObject.Permissions.PSObject.Properties) {
                $properties[$permission.Name] = $permission.Value
            }
        }
        $result = New-Object -TypeName PSObject -Property $properties
        $result.PSObject.TypeNames.Insert(0, 'TeamViewerPS.UserRole')
        $result | Add-Member -MemberType ScriptMethod -Name 'ToString' -Force -Value {
            Write-Output "[$($this.RoleName)] [$($this.RoleID)] $($this.Permissions))"
        }
        Write-Output $result
    }
}

