function ConvertTo-TeamViewerPredefinedRole {
    param(
        [Parameter(ValueFromPipeline = $true)]
        [PSObject]
        $InputObject
    )

    process {
        $Properties = @{
            PredefinedRoleId = $InputObject.PredefinedUserRoleId
        }

        $Result = New-Object -TypeName PSObject -Property $Properties
        $Result.PSObject.TypeNames.Insert(0, 'TeamViewerPS.PredefinedRole')
        $Result | Add-Member -MemberType ScriptMethod -Name 'ToString' -Force -Value {
            "[$($this.PredefinedRoleID)]"
        }

        Write-Output $Result
    }
}
