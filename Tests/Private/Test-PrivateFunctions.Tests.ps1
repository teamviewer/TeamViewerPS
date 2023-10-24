BeforeAll {
    $Script:Module_RootPath = (Resolve-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath '..\..'))
    $Script:Module_FilePath = (Get-ChildItem -Path (Join-Path -Path $Module_RootPath -ChildPath 'Cmdlets') -Filter '*.psm1' -File).FullName
    $Script:Module_Name = (Split-Path -Path $Module_FilePath -Leaf).Replace('.psm1', '')
    $Script:Module_ManifestFilePath = (Get-ChildItem -Path (Join-Path -Path $Module_RootPath -ChildPath 'Cmdlets') -Filter '*.psd1' -File).FullName
    $Script:Module_PrivFunctionNames = (Get-ChildItem -Path (Join-Path -Path $Module_RootPath -ChildPath 'Cmdlets\Private') -Filter '*.ps1' -File | Select-Object BaseName)
}

Context 'Test-PrivateFunctions' {
    $Test_Case = $Module_PrivFunctionNames | ForEach-Object { @{ PrivFunction = $_ } }

    It 'Private functions not accessible from outside' -TestCases $Test_Case {
        param($PrivFunction)

        { . $PrivFunction } | Should -Throw
    }
}
