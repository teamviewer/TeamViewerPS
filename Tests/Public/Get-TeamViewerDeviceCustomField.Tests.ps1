BeforeAll {
    . "$PSScriptRoot\..\..\Cmdlets\Public\Get-TeamViewerDeviceCustomField.ps1"
    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }

    $testAPIToken = [securestring]@{}
    $null = $testAPIToken
}

Describe 'Get-TeamViewerDeviceCustomField' {
    It 'Should get all device custom field values for a managed device' {
        Mock Get-TeamViewerAPIUri { '//unit.test' }
        Mock Resolve-TeamViewerManagedDeviceId { 'd12345678' }
        Mock Invoke-TeamViewerRestMethod {
            @{ resources = @(
                    @{ id = '00000000-0000-0000-0000-000000000010'; fieldKeyId = '00000000-0000-0000-0000-000000000001'; value = 'AssetTag001'; createdAt = '2026-01-01T00:00:00+00:00'; updatedAt = '2026-01-02T00:00:00+00:00' },
                    @{ id = '00000000-0000-0000-0000-000000000020'; fieldKeyId = '00000000-0000-0000-0000-000000000002'; value = 'SerialNumber123'; createdAt = '2026-01-03T00:00:00+00:00'; updatedAt = '2026-01-04T00:00:00+00:00' }
                )
            }
        }

        $Result = Get-TeamViewerDeviceCustomField -APIToken $testAPIToken -ManagedDeviceId 'd12345678'

        $Result.Count | Should -Be 2
        $Result[0].Id | Should -Be '00000000-0000-0000-0000-000000000010'
        $Result[0].Field_Id | Should -Be '00000000-0000-0000-0000-000000000001'
        $Result[0].Value | Should -Be 'AssetTag001'
        $Result[0].UpdatedAt | Should -BeOfType ([datetime])
        $Result[0].PSObject.TypeNames | Should -Contain 'TeamViewerPS.DeviceCustomField'

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $APIToken -eq $testAPIToken -and
            $Uri -eq '//unit.test/managed/devices/d12345678/custom-fields' -and
            $Method -eq 'Get'
        }
    }

    It 'Should accept pipeline input' {
        Mock Get-TeamViewerAPIUri { '//unit.test' }
        Mock Resolve-TeamViewerManagedDeviceId { 'd12345678' }
        Mock Invoke-TeamViewerRestMethod {
            @{ resources = @(@{ fieldKeyId = '00000000-0000-0000-0000-000000000001'; value = 'Test' }) }
        }

        'd12345678' | Get-TeamViewerDeviceCustomField -APIToken $testAPIToken

        Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
            $Uri -eq '//unit.test/managed/devices/d12345678/custom-fields'
        }
    }
}
