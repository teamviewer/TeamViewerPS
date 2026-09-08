enum TeamViewerConnectionReportSessionType {
    RemoteConnection = 1
    RemoteSupportActive = 2
    RemoteSupportActiveSdk = 3
}

enum PolicyType {
    TeamViewer = 1
    Monitoring = 4
    PatchManagement = 5
}

enum ConditionalAccessFeatureAccessLevel {
    Allow = 0
    AfterConfirmation = 1
    Denied = 2
}

enum ConditionalAccessSourceTargetType {
    AccountId = 0
    GroupId = 1
    DyngateId = 2
    DirectoryGroupId = 3
    ManagedGroupId = 4
    UserGroupId = 5
}

enum ConditionalAccessRuleState {
    Valid = 0
    SourceInvalid = 1
    TargetInvalid = 2
    BothInvalid = 3
}
