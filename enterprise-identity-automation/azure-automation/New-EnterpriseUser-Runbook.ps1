param (
    [Parameter(Mandatory)]
    [string]$FirstName,

    [Parameter(Mandatory)]
    [string]$LastName,

    [string]$Email,
    [string]$Department
)

# --- Connect using Managed Identity ---
Connect-AzAccount -Identity

Import-Module ActiveDirectory

Write-Output "Starting user provisioning runbook"

# --- Validation ---
if ($Email -and ($Email -notmatch '^[^@\s]+@[^@\s]+\.[^@\s]+$')) {
    throw "Invalid email format"
}

$sam = ($FirstName.Substring(0,1) + $LastName).ToLower()

# --- Idempotency Check ---
$userExists = Get-ADUser -Filter "SamAccountName -eq '$sam'" -ErrorAction SilentlyContinue

if ($userExists) {
    Write-Output "User $sam already exists. Skipping creation."
    return @{
        Status = "Skipped"
        SamAccountName = $sam
    }
}

# --- Password Generation ---
$passwordPlain = [System.Web.Security.Membership]::GeneratePassword(16,3)
$password = ConvertTo-SecureString $passwordPlain -AsPlainText -Force

# --- Create AD User ---
New-ADUser `
    -Name "$FirstName $LastName" `
    -GivenName $FirstName `
    -Surname $LastName `
    -SamAccountName $sam `
    -UserPrincipalName "$sam@corp.example.com" `
    -EmailAddress $Email `
    -Department $Department `
    -Path "OU=Users,OU=Corp,DC=example,DC=com" `
    -AccountPassword $password `
    -Enabled $true `
    -ChangePasswordAtLogon $true

Write-Output "User $sam successfully created"

# --- Structured Output (Enterprise Pattern) ---
[PSCustomObject]@{
    Status = "Created"
    SamAccountName = $sam
    Department = $Department
}
