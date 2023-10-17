@{
    # Script module or binary module file associated with this manifest.
    RootModule        = 'TeamViewerPS.psm1'

    # Version number of this module.
    ModuleVersion     = '2.0.0'

    # Supported PSEditions.
    # CompatiblePSEditions = @()

    # ID used to uniquely identify this module.
    GUID              = 'd4e57325-dfd9-4391-8259-ce81d2aa7d48'

    # Author of this module.
    Author            = 'TeamViewer Germany GmbH'

    # Company or vendor of this module.
    CompanyName       = 'TeamViewer Germany GmbH'

    # Copyright statement for this module.
    Copyright         = '(c) 2021-2023 TeamViewer Germany GmbH. All rights reserved.'

    # Description of the functionality provided by this module.
    Description       = 'TeamViewerPS allows to interact with the TeamViewer Web API as well as a locally installed TeamViewer client.'

    # Minimum version of the Windows PowerShell engine required by this module.
    PowerShellVersion = '5.1'

    # Name of the Windows PowerShell host required by this module.
    # PowerShellHostName = ''

    # Minimum version of the Windows PowerShell host required by this module.
    # PowerShellHostVersion = ''

    # Minimum version of Microsoft .NET Framework required by this module.
    # DotNetFrameworkVersion = ''

    # Minimum version of the common language runtime (CLR) required by this module.
    # CLRVersion = ''

    # Processor architecture (None, X86, Amd64) required by this module.
    # ProcessorArchitecture = ''

    # Modules that must be imported into the global environment prior to importing this module.
    # RequiredModules = @()

    # Assemblies that must be loaded prior to importing this module.
    # RequiredAssemblies = @()

    # Script files (.ps1) that are run in the caller's environment prior to importing this module.
    # ScriptsToProcess = @()

    # Type files (.ps1xml) to be loaded when importing this module.
    # TypesToProcess = @()

    # Format files (.ps1xml) to be loaded when importing this module.
    FormatsToProcess  = @('TeamViewerPS.format.ps1xml')

    # Modules to import as nested modules of the module specified in RootModule/ModuleToProcess.
    # NestedModules = @()

    # Functions to export from this module.
    FunctionsToExport = @('Add-TeamViewerAssignment', 'Add-TeamViewerCustomization', 'Add-TeamViewerManagedDevice', 'Add-TeamViewerManager', 'Add-TeamViewerAccountToUserRole', 'Add-TeamViewerUserGroupToUserRole', 'Add-TeamViewerSsoExclusion', 'Add-TeamViewerUserGroupMember', 'Connect-TeamViewerApi', 'Disconnect-TeamViewerApi', 'Export-TeamViewerSystemInformation', 'Get-TeamViewerAccount', 'Get-TeamViewerConnectionReport', 'Get-TeamViewerContact', 'Get-TeamViewerCustomModuleId', 'Get-TeamViewerDevice', 'Get-TeamViewerEventLog', 'Get-TeamViewerGroup', 'Get-TeamViewerId', 'Get-TeamViewerInstallationDirectory', 'Get-TeamViewerLogFilePath', 'Get-TeamViewerManagedDevice', 'Get-TeamViewerManagedGroup', 'Get-TeamViewerManagementId', 'Get-TeamViewerManager', 'Get-TeamViewerPolicy', 'Get-TeamViewerRoleAssignmentToAccount', 'Get-TeamViewerRoleAssignmentToUserGroup', 'Get-TeamViewerService', 'Get-TeamViewerSsoDomain', 'Get-TeamViewerSsoExclusion', 'Get-TeamViewerUser', 'Get-TeamViewerUserGroup', 'Get-TeamViewerUserGroupMember', 'Get-TeamViewerUserRole', 'Get-TeamViewerVersion', 'Invoke-TeamViewerPackageDownload', 'Invoke-TeamViewerPing', 'New-TeamViewerContact', 'New-TeamViewerDevice', 'New-TeamViewerGroup', 'New-TeamViewerManagedGroup', 'New-TeamViewerPolicy', 'New-TeamViewerUser', 'New-TeamViewerUserGroup', 'New-TeamViewerUserRole', 'Publish-TeamViewerGroup', 'Remove-TeamViewerAssignment', 'Remove-TeamViewerContact', 'Remove-TeamViewerCustomization', 'Remove-TeamViewerDevice', 'Remove-TeamViewerGroup', 'Remove-TeamViewerManagedDevice', 'Remove-TeamViewerManagedDeviceManagement', 'Remove-TeamViewerManagedGroup', 'Remove-TeamViewerManager', 'Remove-TeamViewerPolicy', 'Remove-TeamViewerPolicyFromManagedDevice', 'Remove-TeamViewerPSProxy', 'Remove-TeamViewerAccountFromRole', 'Remove-TeamViewerUserGroupFromUserRole', 'Remove-TeamViewerSsoExclusion', 'Remove-TeamViewerUser', 'Remove-TeamViewerUserGroup', 'Remove-TeamViewerUserGroupMember', 'Remove-TeamViewerUserRole', 'Restart-TeamViewerService', 'Set-TeamViewerAccount', 'Set-TeamViewerAPIUri', 'Set-TeamViewerDevice', 'Set-TeamViewerGroup', 'Set-TeamViewerManagedDevice', 'Set-TeamViewerManagedGroup', 'Set-TeamViewerManager', 'Set-TeamViewerPolicy', 'Set-TeamViewerPSProxy', 'Set-TeamViewerUser', 'Set-TeamViewerUserGroup', 'Set-TeamViewerUserRole', 'Start-TeamViewerService', 'Stop-TeamViewerService', 'Test-TeamViewerConnectivity', 'Test-TeamViewerInstallation', 'Unpublish-TeamViewerGroup')

    # Cmdlets to export from this module.
    CmdletsToExport   = @()

    # Variables to export from this module.
    VariablesToExport = '*'

    # Aliases to export from this module.
    AliasesToExport   = @()

    # DSC resources to export from this module.
    # DscResourcesToExport = @()

    # List of all modules packaged with this module.
    # ModuleList = @()

    # List of all files packaged with this module
    # FileList = @()

    # Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
    PrivateData       = @{
        PSData = @{
            #Prerelease = '-alpha1'
            # Tags applied to this module. These help with module discovery in online galleries.
            # Tags = @()
            Tags       = @(
                'PowerShell',
                'scripting',
                'automation',
                'teamviewer',
                'remotecontrol',
                'webapi',
                'api'
            )

            # A URL to the license for this module.
            LicenseUri = 'https://github.com/teamviewer/TeamViewerPS/blob/main/LICENSE.md'

            # A URL to the main website for this project.
            ProjectUri = 'https://github.com/teamviewer/TeamViewerPS'

            # ReleaseNotes of this module.
            # ReleaseNotes = 'https://github.com/teamviewer/TeamViewerPS/blob/main/CHANGELOG.md'

        } # End of PSData hashtable
    } # End of PrivateData hashtable

    # HelpInfo URI of this module.
    # HelpInfoURI = 'https://github.com/teamviewer/TeamViewerPS/tree/main/Docs'

    # Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
    # DefaultCommandPrefix = ''

}
