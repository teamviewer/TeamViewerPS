# AGENTS.md

Comprehensive guidance for AI coding agents and developers working in this repository.

## Project Overview

TeamViewerPS is a PowerShell module for the TeamViewer Web API and local TeamViewer client management.
Targets Windows PowerShell 5.1 and PowerShell 6+ on Windows.

| Folder | Purpose |
| --- | --- |
| `Cmdlets/Public` | Exported cmdlets (user-facing) |
| `Cmdlets/Private` | Converters, resolvers, internal helpers |
| `Tests/Public` | Tests for public cmdlets |
| `Tests/Private` | Tests for private helpers |
| `Docs/` | User and contributor documentation / help |

## Canonical Commands

Run from the repository root.

```powershell
# Lint
Invoke-ScriptAnalyzer -Path . -Recurse -Settings .\Linters\PSScriptAnalyzer.psd1

# Test
Invoke-Pester -Path .

# Build (requires Invoke-Build)
Invoke-Build -Task Clean
Invoke-Build -Task Build
Invoke-Build -Task Test
```

## Core Editing Principles

- Preserve public function names and parameter contracts unless explicitly asked to change them.
- Prefer existing helpers in `Cmdlets/Private` over new abstractions.
- Follow naming conventions: `ConvertTo-*` for mapping, `Resolve-*` for lookups
- **Pipeline Lifecycle Blocks**: Use `begin`, `process`, and `end` blocks only when their pipeline lifecycle semantics are needed. Handle pipeline parameters in `process`, initialize shared state in `begin`, and flush accumulated or final work in `end`. Do not add empty or ceremonial blocks to scalar-only commands.
- **Pipeline Output Pattern**: Process blocks must use implicit pipeline emission (no `return` or `Write-Output`); non-pipeline functions use explicit `return` statements. This standardizes when values enter the pipeline vs. are explicitly returned.
- Focus on production-grade code quality: security, testability, and maintainability.
- No hardcoding of API tokens, credentials, or environment-specific values.
- Add or update Pester tests for every behavior change; include a regression test for bug fixes.
- Run lint and tests before finishing; both must pass.

---

## Function Naming Conventions

### Cmdlet Naming (Public Functions)

Use standard PowerShell Verb-Noun format:

- **Action verbs**: `Get-`, `Set-`, `New-`, `Remove-`, `Add-`, `Update-`, `Connect-`, `Test-`, `Invoke-`
- **Noun prefix**: `TeamViewer` for consistency
- **Examples**: `Get-TeamViewerUser`, `Set-TeamViewerDevice`, `New-TeamViewerRole`, `Remove-TeamViewerContact`

### Private Function Naming

Categorize private helpers with clear prefixes:

**ConvertTo functions**: Transform API response objects to custom typed PSObjects

- `ConvertTo-TeamViewerUser` - API response → custom User object
- `ConvertTo-ErrorRecord` - REST errors → PowerShell ErrorRecords
- `ConvertTo-TeamViewerRestError` - API error responses → custom objects

**Resolve functions**: Convert flexible input types to standardized API identifiers

- `Resolve-TeamViewerUserId` - Accept User object, ID string, or email; return ID
- `Resolve-TeamViewerDeviceId` - Accept Device object or ID; return ID
- `Resolve-TeamViewerLanguage` - Map CultureInfo to locale format (e.g., zh-CN → zh_CN)

**Helper functions**: General utilities (no specific prefix)

- `Invoke-TeamViewerRestMethod` - Centralized REST API handler
- `Get-TeamViewerApiUri` - Build API endpoint URIs
- `Get-TeamViewerRegKeyPath` - Registry key lookups

---

## Parameter & Input Validation Patterns

### Core Parameters

All API-calling cmdlets follow this structure:

```powershell
[CmdletBinding(DefaultParameterSetName = 'ByParameters')]

param(
    [Parameter(Mandatory = $true)]
    [securestring]
    $ApiToken,

    [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
    $InputObject,  # Can be object, ID string, or alternative identifier
)
```

**Common DefaultParameterSetName values:**

- `'ByParameters'` - For Set-* and similar functions with optional parameters
- `'FilteredList'` - For Get-* functions with filtering options
- `'List'` - For Get-* functions returning a list
- `'ByUserId'`, `'ByDeviceId'`, `'ByGroupId'` - Specific to object type lookup

### Validation Strategies

**Type & Pattern Validation** (using ValidateScript):

```powershell
[ValidateScript( { $_ | Resolve-TeamViewerUserId } )]
[string]
$User
```

This leverages existing Resolve functions for consistent validation.

**Pattern Validation with Regex**:

- User IDs: `u[0-9]+` (prefix + digits)
- Device IDs: `d[0-9]+`
- Include informative error messages: `"Invalid user identifier '$User'. String must be a user ID in the form 'u123456789'."`

**Enumerated Values** (using ValidateSet):

```powershell
[ValidateSet('OnlyShared', 'OnlyNotShared')]
[string]
$ShareMode
```

**Numeric Bounds** (using ValidateRange):

```powershell
[ValidateRange(0, 12)]
[int]
$Months
```

### Aliasing & Convenience Parameters

Provide common alternatives for key parameters:

- `Id` aliases for object-specific ID parameters (`UserId`, `GroupId`, `DeviceId`)
- `DisplayName` and `EmailAddress` for user lookups
- Enables both `Get-TeamViewerUser -UserId u123` and `Get-TeamViewerUser -Id u123`

### Flexible Input Pattern

Resolve functions enable single-parameter flexibility:

```powershell
function Get-TeamViewerUser {
    param(
        [ValidateScript( { $_ | Resolve-TeamViewerUserId } )]
        $User  # Accept: User object, ID string "u123456789", email, custom identifier
    )
}
```

---

## Error Handling & Validation

### Centralized Error Mapping

All REST errors flow through dedicated converters:

- **ConvertTo-ErrorRecord.ps1**: Maps REST error types to PowerShell ErrorCategories
  - `AuthenticationError` for 401/403
  - `InvalidArgument` for 400 validation failures
  - `ObjectNotFound` for 404
  - `PermissionDenied` for authorization issues
  - `ResourceUnavailable` for rate limits

- **ConvertTo-TeamViewerRestError.ps1**: Parses API error responses into custom objects with error code, message, and context

### Error Delegation Pattern

Pass `$PSCmdlet` to centralized REST handler for proper error propagation:

```powershell
$response = Invoke-TeamViewerRestMethod -ApiToken $ApiToken -Method Get -Uri $uri -PSCmdlet $PSCmdlet
```

### Error Code Resolution

Use dedicated hashtable-based resolvers for semantic error mapping:

- `Resolve-TeamViewerAssignmentErrorCode` - Assignment-specific error codes
- `Resolve-TeamViewerCustomizationErrorCode` - Customization error codes
- Include user-friendly messages for each code

### Graceful Degradation

Return `$null` for non-critical failures (e.g., optional date parsing):

```powershell
try { [DateTime]::Parse($InputString) }
catch [System.ArgumentNullException], [System.FormatException] { $null }
```

---

## Object Construction & Type Assignment Patterns

All `ConvertTo-*` functions follow this template:

### 1. Build Property Hashtable

Map API response (snake_case) to PowerShell conventions (PascalCase):

```powershell
$properties = @{
    Id          = $InputObject.id
    Name        = $InputObject.name
    Email       = $InputObject.email
}
```

### 2. Conditionally Include Optional Properties

Check existence before adding:

```powershell
if ($InputObject.last_activity_at) {
    $properties['LastActivityAt'] = [DateTime]::Parse($InputObject.last_activity_at)
}

if ($InputObject.is_owner) {
    $properties['IsOwner'] = $InputObject.is_owner
}
```

### 3. Create PSObject

```powershell
$result = New-Object -TypeName PSObject -Property $properties
```

### 4. Apply Custom Type

```powershell
$result.PSObject.TypeNames.Insert(0, 'TeamViewerPS.User')
```

### 5. Add ToString() Method

Enables readable output in default views:

```powershell
$result | Add-Member -MemberType ScriptMethod -Name 'ToString' `
    -Value { "{0} ({1})" -f $this.Name, $this.Id } -Force
```

### 6. Emit via Pipeline with Explicit Emission

```powershell
# Use explicit Write-Output for clarity and consistency
Write-Output $result
```

---

## Pipeline & Output Conventions

### Process Block Pattern

Functions handling pipeline input use **Process blocks** for correct multiple-object handling:

```powershell
process {
    # Handle $_ from pipeline and emit explicitly
    $result = $_ | Some-Pipeline-Operation
    Write-Output $result
}
```

### Output Emission Rules

- **Pipeline functions** (Process blocks): Use explicit `Write-Output` for all output
- **Non-pipeline functions**: Use explicit `Write-Output` for all output; reserve `return` for flow control
- **No output functions** (e.g., `Connect-TeamViewerApi`): Have no output; perform side effects only

**Rationale**: Explicit emission makes intent clear, prevents accidental pipeline output, and improves code readability

### Multiple Parameter Sets

Use `DefaultParameterSetName` and structure to support different input modes:

```powershell
[CmdletBinding(DefaultParameterSetName = 'FilteredList')]

param(
    [Parameter(Mandatory = $true)]
    [securestring]
    $ApiToken,

    [Parameter(ParameterSetName = 'ByUserId', ValueFromPipeline = $true)]
    [ValidateScript( { $_ | Resolve-TeamViewerUserId } )]
    [Alias('Id')]
    [string]
    $User,

    [Parameter(ParameterSetName = 'FilteredList')]
    [string]
    $Name,

    [Parameter(ParameterSetName = 'FilteredList')]
    [string]
    $Email,
)
```

**Parameter Set Naming Conventions:**

- `'FilteredList'` - Default set with optional filters (Get-TeamViewerUser, Get-TeamViewerDevice, etc.)
- `'ByUserId'`, `'ByDeviceId'` - Alternative sets for specific object lookup by ID
- `'ByParameters'` - Default for Set-* functions with optional property parameters
- `'ByProperties'` - Alternative set using properties (e.g., Set-TeamViewerUser)

---

## Secure String Handling

Consistent pattern across all functions handling sensitive data (`ApiToken`, `Password`, `SsoCustomerIdentifier`):

```powershell
$bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($ApiToken)
$plainText = [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($bstr)
[System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr) | Out-Null
# Use $plainText, never log it or expose in error messages
```

### Best Practices

- Always convert SecureString immediately before use
- Never store plaintext copies; use converted value directly in operations
- Clear BSTR memory with ZeroFreeBSTR to prevent credential leakage
- Never include plaintext credentials in error messages or logging
- Use `-AsSecureString` parameter in tests, never hardcode tokens

---

## REST API & HTTP Patterns

### Centralized REST Handler

All HTTP operations use `Invoke-TeamViewerRestMethod` (`Cmdlets/Private/Invoke-TeamViewerRestMethod.ps1`):

**Features:**

- Bearer token authentication from SecureString ApiToken (marshaled internally)
- Proxy support via global variables + environment variables
- TLS 1.2 enforcement: `[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12`
- Progress suppression: `$ProgressPreference = 'SilentlyContinue'`
- Uses `Invoke-WebRequest` (not RestMethod) for Windows Server 2012 compatibility
- PS 7.5+ feature: `-DateKind String` prevents locale-dependent date parsing

**Signature:**

```powershell
Invoke-TeamViewerRestMethod -ApiToken <securestring> -Method <string> -Uri <string>
    [-Body <byte[]>] [-PSCmdlet <PSCmdlet>] [-ErrorAction <ActionPreference>]
```

### Request Body Construction

Build bodies using hashtables, then serialize to UTF8 JSON:

```powershell
$body = @{}
if ($PSBoundParameters.ContainsKey('Active')) {
    $body['active'] = $Active
}
if ($Email) {
    $body['email'] = $Email
}

$bodyBytes = [System.Text.Encoding]::UTF8.GetBytes(($body | ConvertTo-Json))
$response = Invoke-TeamViewerRestMethod -ApiToken $ApiToken -Method Post -Uri $uri -Body $bodyBytes
```

### URI Construction

Use `Get-TeamViewerApiUri` to build consistent API endpoints:

```powershell
$apiUri = Get-TeamViewerApiUri -ApiVersion '1' -Endpoint 'users'  # //api/v1/users
$userUri = Get-TeamViewerApiUri -ApiVersion '1' -Endpoint "users/$UserId"
```

---

## Code Organization Within Functions

### Block Structure

Organize complex functions using Begin/Process/End blocks:

**Begin Block**: Initialization

```powershell
begin {
    # Resolve input parameters to API identifiers
    $resolvedUserId = $User | Resolve-TeamViewerUserId

    # Build URI template
    $uri = Get-TeamViewerApiUri -ApiVersion '1' -Endpoint "users/$resolvedUserId"

    # Create reusable body template
    $bodyTemplate = @{ }
}
```

**Process Block**: Handle pipeline input

```powershell
process {
    # Main operation on current pipeline item
    $_ | ConvertTo-TeamViewerUser
}
```

**End Block**: Batch operations or cleanup

```powershell
end {
    # Example: Add-TeamViewerUserGroupMember batches in 100-item chunks
    $batch = @()
    foreach ($item in $inputObjects) {
        $batch += $item
        if ($batch.Count -ge 100) {
            # Process batch
            $batch = @()
        }
    }

    # Process remaining items
}
```

### Local Variable Scoping

Use descriptive names for clarity:

```powershell
# Good
$resolvedUserId = $User | Resolve-TeamViewerUserId
$userUri = Get-TeamViewerApiUri -ApiVersion '1' -Endpoint "users/$resolvedUserId"

# Avoid unclear abbreviations
$uid = ...
$uri_user = ...
```

---

## Comments & Documentation Approach

### When to Comment

Comment **why**, not **what**:

✅ **Good**:

```powershell
# Using Invoke-WebRequest instead of Invoke-RestMethod due to PUT/DELETE hangs on Windows Server 2012
$response = Invoke-WebRequest -Uri $uri -Method Put -Body $bodyBytes
```

✅ **Good**:

```powershell
# Check type before pattern validation to avoid parsing string representations of IDs
if ($InputObject -is [object] -and $InputObject.PSObject.TypeNames -contains 'TeamViewerPS.User') {
```

❌ **Avoid**:

```powershell
# Split the string by comma
$parts = $InputString -split ','
```

### PSAnalyzer Suppression Explanations

Always include a comment explaining why a suppression is needed:

```powershell
# PSAnalyzer: Suppress warning about uninitialized variable — it's initialized conditionally
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseInitializedVariable', '')]
```

### Documentation Structure

- **Function-level comments**: Describe purpose, parameters, and return values in help documentation
- **GitHub references**: Link to issue numbers in CHANGELOG entries for traceability
- **Help files**: Every public function must have a corresponding markdown help file in `Docs/Help/`
- **Markdown structure**: Use `Docs/TeamViewerPS.md` as the main reference, organized by category and alphabetically

---

## Input Validation Best Practices

### Type Checking Strategy

Check custom type names for object validation:

```powershell
if ($InputObject.PSObject.TypeNames -contains 'TeamViewerPS.User') {
    $InputObject.Id
}
```

### Sequential Validation

Validate early before API calls:

```powershell
# Validate input type/format
if (-not ($Input | Test-ValidFormat)) {
    throw "Invalid input format"
}

# Resolve identifiers
$resolvedId = $Input | Resolve-TeamViewerUserId

# Build requests
$uri = Get-TeamViewerApiUri -Endpoint "users/$resolvedId"

# Execute API call
$response = Invoke-TeamViewerRestMethod -Uri $uri -ApiToken $ApiToken
```

### Switch Routing

Use switch statements for parameter set routing:

```powershell
switch ($PSCmdlet.ParameterSetName) {
    'ById' {
        $uri = Get-TeamViewerApiUri -Endpoint "users/$($User | Resolve-TeamViewerUserId)"
    }
    'ByFilter' {
        $uri = Get-TeamViewerApiUri -Endpoint "users?filter=..."
    }
}
```

---

## Edge Cases & Special Handling

### Batch Size Limits

Some APIs have limits on single requests:

- **Add-TeamViewerUserGroupMember**: Batch in 100-item chunks maximum
- **Comment**: Explain limit in code for clarity

### Feature Version Checking

Validate feature support for user's TeamViewer version:

```powershell
# Example: Add-TeamViewerAssignment validates minimum version
if ($TestversionResult.version -lt "15.0") {
    throw "Feature requires TeamViewer 15.0 or later"
}
```

### 32-bit vs 64-bit Detection

Use `Test-TeamViewer32on64.ps1` for Windows 32-bit module detection on 64-bit systems.

### Optional Properties Handling

Never include properties with null/empty values:

```powershell
# Only add if present
if ($InputObject.description) {
    $properties['Description'] = $InputObject.description
}
```

### Date/Time Parsing Robustness

Handle parsing failures gracefully (return `$null` for optional dates):

```powershell
try {
    [DateTime]::Parse($InputString)
}
catch [System.ArgumentNullException], [System.FormatException] {
    $null
}
```

---

## Test Structure & Patterns (Pester)

### Test File Organization

- Test file naming: Match function name exactly: `FunctionName.Tests.ps1`
- Location: `Tests/Public/` for public cmdlets, `Tests/Private/` for private helpers
- One test file per function

### BeforeAll Setup

Dot-source target function and all private dependencies:

```powershell
BeforeAll {
    # Dot-source functions
    . $PSScriptRoot\..\..\Cmdlets\Public\Get-TeamViewerUser.ps1
    . $PSScriptRoot\..\..\Cmdlets\Private\Resolve-TeamViewerUserId.ps1
    . $PSScriptRoot\..\..\Cmdlets\Private\ConvertTo-TeamViewerUser.ps1
    . $PSScriptRoot\..\..\Cmdlets\Private\Invoke-TeamViewerRestMethod.ps1
}
```

### Mocking Strategy

Mock all external dependencies consistently:

```powershell
# Mock REST handler
Mock Invoke-TeamViewerRestMethod {
    return @{
        id = 'u123456789'
        name = 'Test User'
        email = 'test@example.com'
    }
}

# Verify correct parameters passed
Should -Invoke Invoke-TeamViewerRestMethod -Times 1 -Scope It -ParameterFilter {
    $ApiToken -eq $testApiToken -and `
    $Uri -eq '//api/v1/users' -and `
    $Method -eq 'Get'
}
```

### Request Body Validation

Decode UTF8-encoded JSON bodies for assertion:

```powershell
Mock Invoke-TeamViewerRestMethod {
    $decodedBody = [System.Text.Encoding]::UTF8.GetString($Body) | ConvertFrom-Json
    $decodedBody.email | Should -Be 'newemail@example.com'
}
```

### Parametrized Tests

Use `-TestCases` for multiple input scenarios:

```powershell
It "Should convert <InputType> to user object" -TestCases @(
    @{ InputType = 'User object'; Input = $userObject }
    @{ InputType = 'ID string'; Input = 'u123456789' }
    @{ InputType = 'Email'; Input = 'user@example.com' }
) {
    $result = $Input | Resolve-TeamViewerUserId
    $result | Should -BeExactly 'u123456789'
}
```

### Test Naming Conventions

Use descriptive test names that explain the behavior:

```powershell
It "Should retrieve all users when called without filters"
It "Should filter users by ContactPerson parameter"
It "Should throw when ApiToken is invalid"
It "Should accept User object from pipeline"
It "Should throw when UserGroup does not exist"
```

### Integration & Regression Testing

- **Regression tests**: Add tests for any bug fixes to prevent reoccurrence
- **Edge case tests**: Test boundary conditions and unusual inputs
- **Error path tests**: Verify error handling for API failures, invalid inputs, etc.

---

## Module Infrastructure

### Root Module (TeamViewerPS.psm1)

- Dynamically loads all function files
- Initializes module-level variables
- Exports all public function names via manifest

### Types File (TeamViewerPS.Types.ps1)

- Defines custom enums: `TeamViewerConnectionReportSessionType`, `PolicyType`, etc.
- Custom type accelerators for common classes

### Format File (TeamViewerPS.format.ps1xml)

- Defines table views for custom objects (columns, widths, alignment)
- Controls how objects display in default PowerShell views

### Module Manifest (TeamViewerPS.psd1)

- Requires PowerShell 5.1+
- Lists all exported public functions (keep alphabetically sorted)
- Includes version, author, description, and license information

### TeamViewerConfiguration Singleton

Use static pattern for managing API URI state:

```powershell
[TeamViewerConfiguration]::ApiUri  # Default: api.teamviewer.com
[TeamViewerConfiguration]::SetApiUri('custom.api.endpoint')
```

---

## Documentation Standards

### Public Function Documentation

**Every public function must have:**

1. Entry in `Docs/TeamViewerPS.md` (alphabetically within its section)
2. Dedicated help file in `Docs/Help/FunctionName.md`
3. PowerShell help comments in the .ps1 file (visible in `Get-Help`)

### Help File Structure

```markdown
# Get-TeamViewerUser

## SYNOPSIS
Retrieves TeamViewer users from the account.

## SYNTAX
Get-TeamViewerUser -ApiToken <securestring> [[-User] <string>] [...]

## DESCRIPTION
[Detailed description of what the function does]

## PARAMETERS
[Parameter descriptions with types and validation rules]

## OUTPUTS
[Output object type and example structure]

## EXAMPLES
[Real-world usage examples]
```

### Main Documentation (Docs/TeamViewerPS.md)

Organized by category:

- Users
- Groups
- Devices
- Roles
- Licenses
- Contacts
- Settings
- etc.

Within each section, list functions alphabetically with brief description.

---

## Changelog Standards

### Entry Format

- Update `CHANGELOG.md` for **every user-visible change**
- Add entries to the top unreleased section: `x.x.x (YYYY-xx-xx)`
- Use these headings:
  - `Added` - new features
  - `Changed` - modified behavior
  - `Fixed` - bug fixes
  - `Updated` - documentation or dependency updates
  - `Removed` - deprecated functionality
- Keep entries concise and user-facing
- Include GitHub issue links where applicable

### Example Entry

```markdown
## 3.0.0 (2024-01-15)

### Added
- New `Get-TeamViewerConnection` cmdlet for real-time connection info (#45)

### Fixed
- Fixed SecureString handling in `Set-TeamViewerUser` causing intermittent failures (#42)
- Resolved Unicode character encoding in custom email fields

### Changed
- `Get-TeamViewerUser` now returns inactive users by default; use `-ActiveOnly` to filter
```

---

## Pull Request Guidance

### Code Quality Requirements

- ✅ All lint checks pass: `Invoke-ScriptAnalyzer -Path . -Recurse -Settings .\Linters\PSScriptAnalyzer.psd1`
- ✅ All tests pass: `Invoke-Pester -Path .`
- ✅ New functionality includes tests with >95% code coverage
- ✅ Bug fixes include regression tests
- ✅ Documentation updated (help files, CHANGELOG, main docs)
- ❌ No hardcoded API tokens, credentials, or environment-specific values

### PR Description Template

```markdown
## Description
[Brief description of changes]

## Type
- [ ] Feature
- [ ] Bug Fix
- [ ] Documentation
- [ ] Refactoring

## Testing
- [x] Lint passed: `Invoke-ScriptAnalyzer -Path . -Recurse -Settings .\Linters\PSScriptAnalyzer.psd1`
- [x] Tests passed: `Invoke-Pester -Path .`
- [x] Tested against PowerShell 5.1 and PS 7.x
- [ ] Manual testing on Windows environment

## Related Issues
Fixes #123 / Related to #456
```

### Scope & Focus

- Keep PRs focused on single features or bug fixes
- Target the `main` branch
- Avoid mixing refactoring with functional changes
- Use separate PRs for breaking changes or major refactors
- Link to related issues for traceability

---

## Security & Best Practices

### Credential Handling

- ✅ Accept credentials as `[securestring]` parameters
- ✅ Marshal SecureString to plaintext only when immediately needed
- ✅ Zero memory after use with `ZeroFreeBSTR`
- ❌ Never log plaintext credentials
- ❌ Never include in error messages
- ❌ Never store in files or environment variables

### API Token Management

- ✅ Pass as SecureString through pipeline parameters
- ✅ Document how to generate tokens securely
- ❌ Never embed in scripts
- ❌ Never check into version control
- ❌ Never assume token security from client-side validation

### Input Sanitization

- Validate all user input before API calls
- Use pattern matching for ID strings
- Use ValidateScript for complex validation
- Provide informative error messages

### Proxy & Network Security

- Support corporate proxy configuration
- Respect environment variable settings
- Use TLS 1.2 minimum (enforced in Invoke-TeamViewerRestMethod)
- Document any network-level prerequisites

---

## Performance Considerations

### Batch Operations

When processing multiple items:

- Use End blocks to batch API calls
- Respect API limits (e.g., 100-item batches for Add-TeamViewerUserGroupMember)
- Show progress for long-running operations

### Caching

- Cache frequently-accessed data (e.g., user lookups)
- Provide `-Force` parameter to bypass cache when needed
- Document cache behavior

### Memory Management

- Clean up large collections explicitly
- Use `Remove-Variable` for temporary large objects
- Dispose resources in End blocks

---

## Common Patterns to Reuse

### Convert Input to Typed Object

```powershell
$inputObject | Resolve-TeamViewerUserId | Get-TeamViewerUser
```

### Validate Parameter Before Use

```powershell
[ValidateScript( { $_ | Resolve-TeamViewerUserId } )]
[string]
$User
```

### Build & Execute API Request

```powershell
$uri = Get-TeamViewerApiUri -Endpoint "users/$UserId"
$response = Invoke-TeamViewerRestMethod -ApiToken $ApiToken -Method Get -Uri $uri -PSCmdlet $PSCmdlet
$response | ConvertTo-TeamViewerUser
```

### Support WhatIf & Confirm

```powershell
[CmdletBinding(SupportsShouldProcess = $true)]

param()

if ($PSCmdlet.ShouldProcess($targetName, "Change device entry")) {
    # Perform the operation
}
```

---

## Testing Checklist Before Committing

- [ ] Lint passes: `Invoke-ScriptAnalyzer -Path . -Recurse -Settings .\Linters\PSScriptAnalyzer.psd1`
- [ ] All tests pass: `Invoke-Pester -Path .`
- [ ] New tests added for new functionality
- [ ] Regression tests added for bug fixes
- [ ] Code follows naming conventions
- [ ] Pipeline output pattern correct (no inappropriate returns)
- [ ] Error handling uses centralized converters
- [ ] No hardcoded credentials or environment values
- [ ] Help documentation updated
- [ ] CHANGELOG.md updated with user-facing changes
- [ ] Docs/TeamViewerPS.md updated if public functions added/changed
- [ ] SecureString handling follows Marshal pattern
- [ ] Tests verify correct API endpoints and methods called
