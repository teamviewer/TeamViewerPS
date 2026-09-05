BeforeAll {
    $script:OriginalProxyUri = $global:TeamViewerPS_ProxyUri
    $script:OriginalProcessProxyUri = [Environment]::GetEnvironmentVariable('TeamViewerPS_ProxyUri', 'Process')
    $script:OriginalUserProxyUri = [Environment]::GetEnvironmentVariable('TeamViewerPS_ProxyUri', 'User')

    . "$PSScriptRoot\..\..\Cmdlets\Public\Set-TeamViewerPSProxy.ps1"
    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }
}

AfterAll {
    $global:TeamViewerPS_ProxyUri = $script:OriginalProxyUri
    [Environment]::SetEnvironmentVariable('TeamViewerPS_ProxyUri', $script:OriginalProcessProxyUri, 'Process')
    [Environment]::SetEnvironmentVariable('TeamViewerPS_ProxyUri', $script:OriginalUserProxyUri, 'User')
}

Describe 'Set-TeamViewerPSProxy' {
    BeforeEach {
        $global:TeamViewerPS_ProxyUri = $null
        [Environment]::SetEnvironmentVariable('TeamViewerPS_ProxyUri', $null, 'Process')
        [Environment]::SetEnvironmentVariable('TeamViewerPS_ProxyUri', $null, 'User')
    }

    Context 'When setting the proxy URI' {
        It 'Should set the global variable TeamViewerPS_ProxyUri' {
            $expectedProxyUri = 'http://example.com/proxy'

            Set-TeamViewerPSProxy -ProxyUri $expectedProxyUri
            $global:TeamViewerPS_ProxyUri | Should -Be $expectedProxyUri
        }

        It 'Should set the process environment variable TeamViewerPS_ProxyUri' {
            $expectedProxyUri = 'http://example.com/proxy'

            Set-TeamViewerPSProxy -ProxyUri $expectedProxyUri
            [Environment]::GetEnvironmentVariable('TeamViewerPS_ProxyUri', 'Process') | Should -Be $expectedProxyUri
        }

        It 'Should set the persisted environment variable' {
            $expectedProxyUri = 'http://example.com/proxy'

            Set-TeamViewerPSProxy -ProxyUri $expectedProxyUri
            [Environment]::GetEnvironmentVariable('TeamViewerPS_ProxyUri', 'User') | Should -Be $expectedProxyUri
        }
    }

    Context 'When WhatIf is specified' {
        It 'Should not change the global or environment proxy URI' {
            $initialProxyUri = 'http://example.com/initial-proxy'
            $newProxyUri = 'http://example.com/new-proxy'
            $global:TeamViewerPS_ProxyUri = $initialProxyUri
            [Environment]::SetEnvironmentVariable('TeamViewerPS_ProxyUri', $initialProxyUri, 'Process')
            [Environment]::SetEnvironmentVariable('TeamViewerPS_ProxyUri', $initialProxyUri, 'User')

            Set-TeamViewerPSProxy -ProxyUri $newProxyUri -WhatIf

            $global:TeamViewerPS_ProxyUri | Should -Be $initialProxyUri
            [Environment]::GetEnvironmentVariable('TeamViewerPS_ProxyUri', 'Process') | Should -Be $initialProxyUri
            [Environment]::GetEnvironmentVariable('TeamViewerPS_ProxyUri', 'User') | Should -Be $initialProxyUri
        }
    }
}
