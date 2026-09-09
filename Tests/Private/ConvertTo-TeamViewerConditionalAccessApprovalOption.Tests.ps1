BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Private\ConvertTo-TeamViewerConditionalAccessApprovalOption.ps1"
}

Describe 'ConvertTo-TeamViewerConditionalAccessApprovalOption' {
    It 'Maps an approval option' {
        $InputObject = [pscustomobject]@{
            optionId = 'b5b8c706-710d-43c5-b775-dc86347d9e56'
            name     = 'Unit Test Approval Option'
            data     = [pscustomobject]@{ accountIds = @(1, 2) }
        }

        $Result = $InputObject | ConvertTo-TeamViewerConditionalAccessApprovalOption

        $Result.PSObject.TypeNames | Should -Contain 'TeamViewerPS.ConditionalAccessApprovalOption'
        $Result.Data.accountIds | Should -Be @(1, 2)
    }
}
