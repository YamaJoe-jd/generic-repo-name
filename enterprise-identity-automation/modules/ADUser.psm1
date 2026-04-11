# modules/ADUser.psm1
Import-Module ActiveDirectory -ErrorAction Stop

function New-EnterpriseADUser {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [hashtable]$User
    )

    # --- Validation ---
    if (-not $User.FirstName -or -not $User.LastName) {
        throw "FirstName and LastName are required."
    }

    if ($User.Email -and ($User.Email -notmatch '^[^@\s]+@[^@\s]+\.[^@\s]+$')) {
        throw "Invalid email format."
    }

    $sam = ($User.FirstName.Substring(0,1) + $User.LastName).ToLower()

    # --- Idempotency check ---
    $existing = Get-ADUser -Filter "SamAccountName -eq '$sam'" -ErrorAction SilentlyContinue
    if ($existing) {
        return @{
            Status = "Skipped"
            Reason = "User already exists"
            SamAccountName = $sam
        }
    }

    # --- Secure password generation ---
    $password = [System.Web.Security.Membership]::GeneratePassword(16,3) |
        ConvertTo-SecureString -AsPlainText -Force

    # --- Create user ---
    New-ADUser `
        -Name "$($User.FirstName) $($User.LastName)" `
        -GivenName $User.FirstName `
        -Surname $User.LastName `
        -SamAccountName $sam `
        -UserPrincipalName "$sam@corp.example.com" `
        -EmailAddress $User.Email `
        -Department $User.Department `
        -Path "OU=Users,OU=Corp,DC=example,DC=com" `
        -AccountPassword $password `
        -Enabled $true `
        -ChangePasswordAtLogon $true

    return @{
        Status = "Created"
        SamAccountName = $sam
    }
}

Export-ModuleMember -Function New-EnterpriseADUser
