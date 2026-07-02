# Windows Account Lockout Monitor
# Run every 10 min via Task Scheduler

$lockoutThreshold = 3
$timeWindow = 10  # minutes

$events = Get-WinEvent -FilterHashtable @{
    LogName='Security'
    ID=4740
    StartTime=(Get-Date).AddMinutes(-$timeWindow)
}

$lockedAccounts = $events | Group-Object -Property {$_.Properties[0].Value}

foreach ($account in $lockedAccounts) {
    if ($account.Count -gt $lockoutThreshold) {
        $msg = "ALERT: Lockout storm for $($account.Name) - $($account.Count) times in $timeWindow min"
        Write-Host $msg
        # Uncomment to send alert:
        # Send-MailMessage -To "soc-lead@company.com" -Subject "Lockout Alert" -Body $msg -From "soc@company.com" -SmtpServer "smtp.company.com"
    }
}
