function ConvertTo-TeamViewerConditionalAccessFeatureOption {
    param(
        [Parameter(ValueFromPipeline)]
        [object]
        $InputObject
    )

    process {
        $Data = [ordered]@{}
        if ($InputObject.data -is [hashtable]) {
            $InputObject.data.GetEnumerator() | ForEach-Object {
                $Data[$_.Key] = [ConditionalAccessFeatureAccessLevel]$_.Value
            }
        }
        else {
            $InputObject.data.PSObject.Properties | ForEach-Object {
                $Data[$_.Name] = [ConditionalAccessFeatureAccessLevel]$_.Value
            }
        }

        $Properties = @{
            OptionId = [guid]$InputObject.optionId
            Name     = $InputObject.name
            Data     = [pscustomobject]$Data
        }

        $Result = New-Object -TypeName PSObject -Property $Properties
        $Result.PSObject.TypeNames.Insert(0, 'TeamViewerPS.ConditionalAccessFeatureOption')

        Write-Output $Result
    }
}
