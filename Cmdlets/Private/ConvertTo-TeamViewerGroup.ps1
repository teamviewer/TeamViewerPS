function ConvertTo-TeamViewerGroup {
    param(
        [Parameter(ValueFromPipeline)]
        [object]
        $InputObject
    )

    process {
        $Properties = @{
            Id          = $InputObject.id
            Name        = $InputObject.name
            Permissions = $InputObject.permissions
            Policy_Id   = $InputObject.policy_id
            Shared_With = @($InputObject.shared_with | ConvertTo-TeamViewerGroupShare)
        }

        if ($InputObject.owner) {
            $Properties.Owner = [pscustomobject]@{
                Id   = $InputObject.owner.userid
                Name = $InputObject.owner.name
            }
        }

        $Result = New-Object -TypeName PSObject -Property $Properties
        $Result.PSObject.TypeNames.Insert(0, 'TeamViewerPS.Group')

        Write-Output $Result
    }
}
