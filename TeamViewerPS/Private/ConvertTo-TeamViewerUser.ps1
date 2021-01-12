function ConvertTo-TeamViewerUser {
    param(
        [Parameter(ValueFromPipeline)]
        [PSObject]
        $InputObject,

        [Parameter()]
        [ValidateSet('All', 'Minimal')]
        $PropertiesToLoad = 'All'
    )
    process {
        $properties = @{
            Id    = $InputObject.id
            Name  = $InputObject.name
            Email = $InputObject.email
        }
        if ($PropertiesToLoad -Eq 'All') {
            $properties += @{
                Permissions    = $InputObject.permissions -split ','
                Active         = $InputObject.active
                LastAccessDate = $InputObject.last_access_date | ConvertTo-DateTime
            }
        }
        $result = New-Object -TypeName PSObject -Property $properties
        $result.PSObject.TypeNames.Insert(0, 'TeamViewerPS.User')
        $result | Add-Member -MemberType ScriptMethod -Name "ToString" -Force -Value {
            Write-Output "$($this.Name) <$($this.Email)>"
        }
        Write-Output $result
    }
}