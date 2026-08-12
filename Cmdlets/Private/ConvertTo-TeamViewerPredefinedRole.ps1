function ConvertTo-TeamViewerPredefinedRole {
    param(
        [Parameter(ValueFromPipeline = $true)]
        [PSObject]
        $InputObject
    )

    begin {
        $properties = @{
            PredefinedRoleId = $InputObject.PredefinedUserRoleId
        }
    }

    process {
        $result = New-Object -TypeName PSObject -Property $properties
        $result.PSObject.TypeNames.Insert(0, 'TeamViewerPS.PredefinedRole')
        $result | Add-Member -MemberType ScriptMethod -Name 'ToString' -Force -Value {
            "[$($this.PredefinedRoleID)]"
        }

        $result
    }
}
