BeforeAll {
    . "$PSScriptRoot/../../Docs/Cmdlets/Public/Set-TeamViewerPSProxy.ps1"
    . "$PSScriptRoot/../../Docs/Cmdlets/Public/Remove-TeamViewerPSProxy.ps1"
    @(Get-ChildItem -Path "$PSScriptRoot/../../Docs/Cmdlets/Private/*.ps1") | ForEach-Object { . $_.FullName }

    Mock -CommandName 'Set-TeamViewerPSProxy' -MockWith {
        param (
            [Parameter(Mandatory = $true)]
            [Uri]
            $ProxyUri
        )

        $global:TeamViewerProxyUriSet = $ProxyUri
        $global:TeamViewerProxyUriRemoved = $false
        $global:TeamViewerProxyUriRemoved | Out-Null

        [Environment]::SetEnvironmentVariable('TVProxyUri', $ProxyUri, 'User')
    }

    Mock -CommandName 'Remove-TeamViewerPSProxy' -MockWith {
        $global:TeamViewerProxyUriSet = $null
        $global:TeamViewerProxyUriSet | Out-Null
        $global:TeamViewerProxyUriRemoved = $true
        $global:TeamViewerProxyUriRemoved | Out-Null
        [Environment]::SetEnvironmentVariable('TVProxyUri', '', 'User')
    }
}

Describe 'Set-TeamViewerPSProxy' {
    Context 'When setting the proxy URI' {
        It 'Should set the global variable TeamViewerProxyUriSet' {
            $expectedProxyUri = 'http://example.com/proxy'
            Set-TeamViewerPSProxy -ProxyUri $expectedProxyUri
            $global:TeamViewerProxyUriSet | Should -Be $expectedProxyUri
        }

        It 'Should set the environment variable TeamViewerProxyUri' {
            $expectedProxyUri = 'http://example.com/proxy'
            Set-TeamViewerPSProxy -ProxyUri $expectedProxyUri
            [Environment]::GetEnvironmentVariable('TVProxyUri', 'User') | Should -Be $expectedProxyUri
        }

        It 'Should set the global variable TeamViewerProxyUriRemoved to false' {
            $expectedProxyUri = 'http://example.com/proxy'
            Set-TeamViewerPSProxy -ProxyUri $expectedProxyUri
            $global:TeamViewerProxyUriRemoved | Should -Be $false
            Remove-TeamViewerPSProxy
        }
    }
}
