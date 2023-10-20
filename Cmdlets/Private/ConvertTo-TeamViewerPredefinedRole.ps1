function ConvertTo-TeamViewerPredefinedRole {
    param(
        [Parameter(ValueFromPipeline = $true)]
        [PSObject]
        $InputObject
    )
    process {
        if($InputObject){
        $properties = @{
            PredefinedRoleId = $InputObject.PredefinedRoleId
        }
    }

        $result = New-Object -TypeName PSObject -Property $properties
        $result.PSObject.TypeNames.Insert(0, 'TeamViewerPS.PredefinedRole')
        $result | Add-Member -MemberType ScriptMethod -Name 'ToString' -Force -Value {
            Write-Output "[$($this.PredefinedRoleID)]"
        }
        Write-Output $result
    }
}
