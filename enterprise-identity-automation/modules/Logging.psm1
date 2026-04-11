# modules/Logging.psm1
function Write-AuditLog {
    param (
        [string]$Action,
        [string]$Target,
        [string]$Result
    )

    $message = "$Action | Target=$Target | Result=$Result"

    Write-Output $message

    if (-not [System.Diagnostics.EventLog]::SourceExists("EnterpriseAD")) {
        New-EventLog -LogName Application -Source "EnterpriseAD"
    }

    Write-EventLog `
        -LogName Application `
        -Source "EnterpriseAD" `
        -EventId 1001 `
        -EntryType Information `
        -Message $message
}
Export-ModuleMember -Function Write-AuditLog