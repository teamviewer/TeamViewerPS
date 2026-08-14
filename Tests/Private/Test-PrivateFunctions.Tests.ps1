BeforeDiscovery {
    $Script:Module_RootPath = (Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath '..\..'))
    $Script:Module_CmdletsPath = Join-Path -Path $Module_RootPath -ChildPath 'Cmdlets'
    $Script:Module_PrivateTestsPath = Join-Path -Path $Module_RootPath -ChildPath 'Tests\Private'
    $Script:Module_ManifestFilePath = (Get-ChildItem -Path $Module_CmdletsPath -Filter '*.psd1' -File).FullName
    $Script:Module_PrivFunctionNames = @(Get-ChildItem -Path (Join-Path -Path $Module_CmdletsPath -ChildPath 'Private') -Filter '*.ps1' -File | Select-Object -ExpandProperty BaseName | Sort-Object -Unique)

    $Script:PrivateFunctionTestCases = $Module_PrivFunctionNames | ForEach-Object {
        @{ FunctionName = $_ }
    }
}

BeforeAll {
    {
        $Script:ImportedModule = Import-Module -Name $Module_ManifestFilePath -Force -PassThru -ErrorAction Stop
    } | Should -Not -Throw

    $Script:ExportedFunctionNames = @($ImportedModule.ExportedFunctions.Keys | Sort-Object -Unique)
}

Describe 'Test-PrivateFunctions' {
    It 'Discovers private function files' {
        $Module_PrivFunctionNames | Should -Not -BeNullOrEmpty
    }

    It 'Private function has a corresponding test file: <FunctionName>' -TestCases $PrivateFunctionTestCases {
        param(
            [string]$FunctionName
        )

        Test-Path -Path (Join-Path -Path $Module_PrivateTestsPath -ChildPath "$FunctionName.Tests.ps1") | Should -BeTrue
    }

    It 'Private function is not exported by module: <FunctionName>' -TestCases $PrivateFunctionTestCases {
        param(
            [string]$FunctionName
        )

        $ExportedFunctionNames | Should -Not -Contain $FunctionName
    }
}

AfterAll {
    if (Get-Module -Name $ImportedModule.Name) {
        Remove-Module -Name $ImportedModule.Name -Force
    }
}
