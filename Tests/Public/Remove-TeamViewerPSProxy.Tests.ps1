
BeforeAll {
    $script:OriginalProxyUri = $global:TeamViewerPS_ProxyUri
    $script:OriginalProcessProxyUri = [Environment]::GetEnvironmentVariable('TeamViewerPS_ProxyUri', 'Process')
    $script:OriginalUserProxyUri = [Environment]::GetEnvironmentVariable('TeamViewerPS_ProxyUri', 'User')

    . "$PSScriptRoot\..\..\Cmdlets\Public\Remove-TeamViewerPSProxy.ps1"
    @(Get-ChildItem -Path "$PSScriptRoot\..\..\Cmdlets\Private\*.ps1") | ForEach-Object { . $_.FullName }
}

AfterAll {
    $global:TeamViewerPS_ProxyUri = $script:OriginalProxyUri
    [Environment]::SetEnvironmentVariable('TeamViewerPS_ProxyUri', $script:OriginalProcessProxyUri, 'Process')
    [Environment]::SetEnvironmentVariable('TeamViewerPS_ProxyUri', $script:OriginalUserProxyUri, 'User')
}

Describe 'Remove-TeamViewerPSProxy' {
    BeforeEach {
        $global:TeamViewerPS_ProxyUri = 'http://example.com/proxy'
        [Environment]::SetEnvironmentVariable('TeamViewerPS_ProxyUri', 'http://example.com/proxy', 'Process')
        [Environment]::SetEnvironmentVariable('TeamViewerPS_ProxyUri', 'http://example.com/proxy', 'User')
    }

    Context 'When removing the proxy URI' {
        It 'Should clear the global proxy URI' {
            Remove-TeamViewerPSProxy

            $global:TeamViewerPS_ProxyUri | Should -BeNullOrEmpty
        }

        It 'Should remove the process and user environment variables' {
            Remove-TeamViewerPSProxy

            [Environment]::GetEnvironmentVariable('TeamViewerPS_ProxyUri', 'Process') | Should -BeNullOrEmpty
            [Environment]::GetEnvironmentVariable('TeamViewerPS_ProxyUri', 'User') | Should -BeNullOrEmpty
        }
    }

    Context 'When WhatIf is specified' {
        It 'Should preserve the global and environment proxy URI' {
            Remove-TeamViewerPSProxy -WhatIf

            $global:TeamViewerPS_ProxyUri | Should -Be 'http://example.com/proxy'
            [Environment]::GetEnvironmentVariable('TeamViewerPS_ProxyUri', 'Process') | Should -Be 'http://example.com/proxy'
            [Environment]::GetEnvironmentVariable('TeamViewerPS_ProxyUri', 'User') | Should -Be 'http://example.com/proxy'
        }
    }
}
