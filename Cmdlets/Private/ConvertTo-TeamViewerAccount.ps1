function ConvertTo-TeamViewerAccount {
    param(
        [Parameter(ValueFromPipeline)]
        [object]
        $InputObject
    )

    process {
        $Properties = @{
            Name             = $InputObject.name
            Email            = $InputObject.email
            UserId           = $InputObject.userid
            CompanyName      = $InputObject.company_name
            IsEmailValidated = $InputObject.email_validated
            EmailLanguage    = $InputObject.email_language
        }

        if ($InputObject.email_language -and $InputObject.email_language -ne 'auto') {
            $Properties['EmailLanguage'] = [System.Globalization.CultureInfo]($InputObject.email_language)
        }

        $Result = New-Object -TypeName PSObject -Property $Properties
        $Result.PSObject.TypeNames.Insert(0, 'TeamViewerPS.Account')
        $Result | Add-Member -MemberType ScriptMethod -Name 'ToString' -Force -Value {
            "$($this.Name) <$($this.Email)>"
        }

        Write-Output $Result
    }
}
