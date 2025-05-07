# MACHINE_INFO.ps1 - by Alex DeMey - Displays information about the current Windows configuration

# Copyright (c) 2025 Alexander DeMey
# All rights reserved.
# This script is provided under a personal, non-transferable license.
# The author reserves the right to revoke, restrict, or deny usage, reproduction, or distribution
# of this script at any time, without prior notice, to any individual or organization.
# Licensed for use solely within the scope of current professional engagement.
# Any use, reproduction, or distribution outside of that scope shall require prior, written authorization from the author.

function Test-Admin { # return true/false depending on current user local admin rights
    return ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
}

if (-not (Test-Admin)) { # Check if running as admin, if not prompt for Y/N to attempt re-launch as admin
    Write-Host "This script requires administrative privileges to function correctly." -ForegroundColor Yellow
    $response = Read-Host "Would you like to relaunch this script as Admin in Windows Terminal? (Y/N)"
    
    if ($response -eq 'Y') {
        # Relaunch script in Windows Terminal as admin
        $wtPath = "wt.exe"

        # We need to escape the script path correctly
        $scriptPath = "`"$PSCommandPath`""

        # Start Windows Terminal with admin privileges, running PowerShell script in the default profile
        Start-Process $wtPath -ArgumentList "powershell.exe -NoExit -File $scriptPath" -Verb RunAs
        exit  # Exit current session after relaunching
    } elseif ($response -eq 'N') {
        Write-Host "Proceeding without admin rights..." -ForegroundColor Yellow
    }
}

# CURRENT USER INFO
function GetCurrentUserIdentity { # Shows the current user's name, in green text if Admin, red if not.
    try {
        $userName = $null
        $isAdmin = $false

        # Try interactive session via explorer.exe (usually works when explorer is tied to an actual user)
        try {
            $explorerProc = Get-Process -Name explorer -ErrorAction Stop | Select-Object -First 1
            $owner = (Get-CimInstance Win32_Process -Filter "ProcessId = $($explorerProc.Id)").GetOwner()
            if ($owner.User) {
                $userName = "$($owner.Domain)\$($owner.User)"
            }
        } catch {
            # Suppress and fall back to token owner
        }

        # Fallback to current identity if explorer method fails
        if (-not $userName) {
            $userName = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
        }

        # Admin check based on current token
        $principal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
        $isAdmin = $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

        $color = if ($isAdmin) { "Green" } else { "Red" }
        Write-Host "$userName" -ForegroundColor $color -NoNewLine
    } catch {
        Write-Host "Unknown (identity detection failed)" -ForegroundColor DarkRed -BackgroundColor White -NoNewLine
    }
}
function ListAllUsersWithAdminStatus { # Lists Local and Domain/Azure accounts, as well as info on each. 
    $adminGroupMembers = Get-LocalGroupMember -Group "Administrators" -ErrorAction SilentlyContinue
    $currentUserFull = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
    $currentUserShort = $currentUserFull.Split('\')[-1]

    $localUsers = Get-LocalUser
    $defaultAccounts = @('DefaultAccount', 'Guest', 'WDAGUtilityAccount', 'Administrator', 'WsiAccount') # Default users to omit, unless they are enabled.

    # Build set of local usernames (short names)
    $localUsernames = $localUsers.Name

    Write-Host "~~~" -NoNewline
    Write-Host "Local Users" -ForegroundColor Green -BackgroundColor DarkGray -NoNewline
    Write-Host "~~~"

    foreach ($user in $localUsers) {
        $username = $user.Name
        $isEnabled = $user.Enabled
        $isCurrent = $username -eq $currentUserShort
        $isAdmin = $false

        foreach ($admin in $adminGroupMembers) {
            $adminNameShort = $admin.Name.Split('\')[-1]
            if ($adminNameShort -eq $username) {
                $isAdmin = $true
                break
            }
        }

        if (-not $isEnabled -and ($defaultAccounts -contains $username)) {
            continue
        }

        if ($isCurrent) {
            Write-Host "* " -NoNewline -ForegroundColor Cyan
        } else {
            Write-Host "- " -NoNewline -ForegroundColor Gray
        }

        Write-Host "$username " -NoNewline -ForegroundColor White

        if ($isAdmin) {
            Write-Host "(Admin) " -NoNewline -ForegroundColor Green
        } else {
            Write-Host "(Not Admin) " -NoNewline -ForegroundColor Red
        }

        if ($isEnabled) {
            Write-Host "(ENABLED) " -NoNewline -ForegroundColor Green
        } else {
            Write-Host "(DISABLED) " -NoNewline -ForegroundColor Red
        }

        if ($defaultAccounts -contains $username) {
            Write-Host "(Default Account)" -ForegroundColor DarkGray
        } else {
            Write-Host ""
        }
    }

    # Properly filter out only the non-local admin entries
    $nonLocalAdmins = $adminGroupMembers | Where-Object {
        $adminShortName = $_.Name.Split('\')[-1]
        return -not ($localUsernames -contains $adminShortName)
    }

    if ($nonLocalAdmins.Count -gt 0) {
        Write-Host "~~~" -NoNewline
        Write-Host "Azure AD / Domain Accounts in Administrators Group" -ForegroundColor Cyan -BackgroundColor DarkGray -NoNewline
        Write-Host "~~~"

        foreach ($member in $nonLocalAdmins) {
            $isCurrent = ($member.Name -eq $currentUserFull)

            if ($isCurrent) {
                Write-Host "* " -NoNewline -ForegroundColor Cyan
            } else {
                Write-Host "- " -NoNewline -ForegroundColor Gray
            }

            Write-Host "$($member.Name) " -NoNewline -ForegroundColor White
            Write-Host "(Admin) (AAD/Domain Account)" -ForegroundColor Green
        }
    }
}
# HARDWARE INFO
function GetDeviceName { # $global:DeviceName
    $global:DeviceName = $env:COMPUTERNAME
    Write-Host "$($global:DeviceName)" -ForegroundColor Yellow -NoNewline
}
function GetSerialNumber { # $global:serialNumber
    $global:serialNumber = "Not Found"

    try {
        $serial = (Get-WmiObject Win32_BIOS).SerialNumber
        if ($serial) {
            $global:serialNumber = $serial.Trim()
        }
    } catch {
        $global:serialNumber = "Not Found"
    }

    if ($global:serialNumber -ne "Not Found") {
        Write-Host "$($global:serialNumber)" -ForegroundColor Yellow -NoNewline
    } else {
        Write-Host "Not Found" -ForegroundColor Red -NoNewline
    }
}
function GetStorageInfo { # Displays storage drives, and their free space in GB.
    Get-PSDrive -PSProvider 'FileSystem' | ForEach-Object {
        $drive = $_
        $freeGB = [math]::Round($drive.Free / 1GB, 0)

        # Determine color for free space
        if ($freeGB -lt 50) {
            $color = 'Red'
        } elseif ($freeGB -lt 100) {
            $color = 'Yellow'
        } else {
            $color = 'Green'
        }

        Write-Host "$($drive.Name):\" -ForegroundColor Cyan -NoNewline
        Write-Host " - " -ForegroundColor White -NoNewline
        Write-Host "$freeGB" -ForegroundColor $color -NoNewline
        Write-Host "GB Free"
    }
}
# NETWORK INFO
function GetNetworkType { # $global:NetworkType
    $global:NetworkType = "Unknown"
    $adapter = Get-NetAdapter | Where-Object { $_.Status -eq "Up" -and !$_.Virtual } | Select-Object -First 1

    if ($adapter) {
        if ($adapter.Name -match "Wi-Fi|Wireless") {
            $global:NetworkType = "WiFi"
            Write-Host "WiFi" -ForegroundColor Cyan -NoNewline
        } elseif ($adapter.Name -match "Ethernet") {
            $global:NetworkType = "Ethernet"
            Write-Host "Ethernet" -ForegroundColor Green -NoNewline
        } else {
            $global:NetworkType = $adapter.Name
            Write-Host "$($adapter.Name)" -ForegroundColor Yellow -NoNewline
        }
    } else {
        $global:NetworkType = "No Internet"
        Write-Host "No Internet" -ForegroundColor Red -NoNewline
    }
}
function GetDomainStatus { # Writes Domain Join Status ($global:DomainStatus), and Domain Name. 
    $global:DomainStatus = ""
    $dsregOutput = dsregcmd /status

    # Extract the values for AzureAdJoined and DomainJoined
    $azureAdJoined = ($dsregOutput | Select-String "AzureAdJoined\s*:\s*(\w+)" | ForEach-Object { $_.Matches[0].Groups[1].Value }) -eq 'YES'
    $domainJoined  = ($dsregOutput | Select-String "DomainJoined\s*:\s*(\w+)"   | ForEach-Object { $_.Matches[0].Groups[1].Value }) -eq 'YES'

    # Local domain name (if any)
    $localDomain = (Get-WmiObject -Class Win32_ComputerSystem).Domain
    $entraDomain = ""

    # Only attempt to parse Entra domain if AzureAD joined
    if ($azureAdJoined) {
        $aadInfo = $dsregOutput | Select-String "TenantName"
        if ($aadInfo) {
            $entraDomain = ($aadInfo.ToString() -replace 'TenantName\s*:\s*', '').Trim()
        }
    }

    # Determine the domain status
    if ($azureAdJoined -and $domainJoined) {
        $global:DomainStatus = "Hybrid"
        Write-Host "Hybrid: $localDomain/$entraDomain" -ForegroundColor Yellow -NoNewline
    }
    elseif ($azureAdJoined) {
        $global:DomainStatus = "Entra"
        Write-Host "Entra: $entraDomain" -ForegroundColor Cyan -NoNewline
    }
    elseif ($domainJoined) {
        $global:DomainStatus = "Local"
        Write-Host "Local: $localDomain" -ForegroundColor Green -NoNewline
    }
    else {
        $global:DomainStatus = "None"
        Write-Host "None" -ForegroundColor Red -NoNewline
    }
}
function GetHardwareMAC { # Writes Hardware MAC Address ($global:HardwareMAC)
    $MAC = Get-NetAdapter | Where-Object { $_.Status -eq 'Up' -and !$_.Virtual } | Select-Object -ExpandProperty MacAddress
    if ($MAC) {
        $global:HardwareMAC = $MAC
        Write-Host "$MAC" -ForegroundColor Green  -NoNewline
    } else {
        $global:HardwareMAC = "Not Found"
        Write-Host "Not Found" -ForegroundColor Red  -NoNewline
    }
}
function GetIPv4Address { # Writes IPv4 address for first adapter w Internet access.
    # Get the interface index for the default route (0.0.0.0/0)
    $defaultRoute = Get-NetRoute -DestinationPrefix "0.0.0.0/0" |
        Where-Object { $_.NextHop -ne "::" } |
        Sort-Object -Property RouteMetric |
        Select-Object -First 1

    if ($null -eq $defaultRoute) {
        Write-Host "No active internet-connected IPv4 adapter found" -ForegroundColor Red -NoNewline
        return
    }

    $ifIndex = $defaultRoute.InterfaceIndex

    # Get the corresponding IPv4 address
    $ipAddress = Get-NetIPAddress -AddressFamily IPv4 -InterfaceIndex $ifIndex |
        Where-Object { $_.IPAddress -notlike '169.254.*' } |  # Exclude APIPA
        Select-Object -ExpandProperty IPAddress -First 1

    if ($ipAddress) {
        Write-Host "$ipAddress" -ForegroundColor Green -NoNewline
    } else {
        Write-Host "No valid IPv4 address found for active interface" -ForegroundColor Red -NoNewline
    }
}
# SOFTWARE INFO
function GetWindowsVersion { # $global:WindowsVersion, contains OS Name, feature update version, and build number
    try {
        $winRegPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion"
        $props = Get-ItemProperty -Path $winRegPath

        $productName = $props.ProductName
        $releaseId = $props.ReleaseId
        $displayVersion = $props.DisplayVersion
        $currentBuild = [int]$props.CurrentBuild
        $ubr = $props.UBR  # Update Build Revision

        $osBuild = "$currentBuild.$ubr"

        # Determine proper base OS name based on build number
        $osName =
            if ($currentBuild -ge 22000) {  # Windows 11 starts at build 22000
                $productName -replace "Windows 10", "Windows 11"
            } else {
                $productName
            }

        # Choose either DisplayVersion or ReleaseId for feature update info
        $featureUpdate = if ($displayVersion) { $displayVersion } elseif ($releaseId) { $releaseId } else { "Unknown" }

        $global:WindowsVersion = "$osName - $featureUpdate - Build $osBuild"

        Write-Host $global:WindowsVersion -ForegroundColor Black -BackgroundColor Cyan -NoNewline
        Write-Host "" -NoNewLine
    } catch {
        $global:WindowsVersion = "Not Found"
        Write-Host "Not Found" -ForegroundColor Red -NoNewline
    }
}
function GetWindowsActivationKey{ # Grabs your current Windows Activation key
	# Retrieve the Windows activation key
	$windowsKey = Get-WmiObject -Query "SELECT OA3xOriginalProductKey FROM SoftwareLicensingService" | Select-Object -ExpandProperty OA3xOriginalProductKey

	# Output the key
	Write-Host "$windowsKey" -ForegroundColor Yellow -NoNewLine
}
function GetLTAgentID { # $global:LTAgentID
    $global:LTAgentID = "Not Found"
    $LTErrorsPath = "C:\Windows\LTSvC\LTErrors.txt"
    $isInstalled = Test-Path $LTErrorsPath

    try {
        $LTagent = Get-ItemProperty -Path "HKLM:\SOFTWARE\LabTech\Service" -Name "ID" -ErrorAction Stop
        if ($LTagent.ID) {
            $global:LTAgentID = $LTagent.ID
        }
    } catch {
        # Silent fail
    }

    # Output with status-aware coloring
    $color = if ($isInstalled) { "Green" } else { "Red" }
    Write-Host $global:LTAgentID -ForegroundColor $color -NoNewline
}
function GetBitlockerRecovery { # Write-Hosts ID and Key for latest Bitlocker 
    $bitlockerInfo = Get-BitLockerVolume -MountPoint "C:" -ErrorAction SilentlyContinue

    if (-not $bitlockerInfo -or $bitlockerInfo.ProtectionStatus -ne 'On') {
        Write-Host "Disabled" -ForegroundColor Red
        return
    }

    $recoveryKeys = $bitlockerInfo.KeyProtector | Where-Object { $_.KeyProtectorType -eq 'RecoveryPassword' }

    if ($recoveryKeys.Count -eq 0) {
        Write-Host "Enabled - NoRecovery!" -ForegroundColor Red
        return
    }

    # Use the last key, which is usually the valid one
    $latestKey = $recoveryKeys[-1]

    $bitlockerID = $latestKey.KeyProtectorId
    $bitlockerRecoveryKey = $latestKey.RecoveryPassword

    Write-Host "Identifier: " -NoNewLine
    Write-Host "$bitlockerID" -ForegroundColor Yellow
    Write-Host "Recovery Key: " -NoNewLine
    Write-Host "$bitlockerRecoveryKey" -ForegroundColor Green

    <# Optional: return as object
    return [PSCustomObject]@{
        Identifier    = $bitlockerID
        RecoveryKey   = $bitlockerRecoveryKey
        Status        = "Enabled"
    }
    #>
}
function GetCrowdstrikeInstallStatus { # Says "Detected" or "Not Found" based on Crowdstrike path existance.
    $exists = Test-Path "C:\Program Files\CrowdStrike"
    if ($exists) {
        Write-Host "Detected" -ForegroundColor Green -NoNewline
    } else {
        Write-Host "Not Found" -ForegroundColor Red -NoNewline
    }
}
function GetCloudRadialInstallStatus { # Says "Detected" or "Not Found" based on CloudRadial executable existance.
    $exists = Test-Path "C:\Program Files (x86)\CloudRadial Agent\CloudRadial.Agent.exe"
    if ($exists) {
        Write-Host "Detected" -ForegroundColor Green -NoNewline
    } else {
        Write-Host "Not Found" -ForegroundColor Red -NoNewline
    }
}

# DISPLAY INFO
function ShowExitSpinner { # Exit spinner - animation; continues on keystroke
    $spinnerChars = @('|', '/', '-', '\')
    $spinnerIndex = 0
    $promptBase = "Press any key to exit"
    $startLeft = [Console]::CursorLeft
    $startTop = [Console]::CursorTop

    [Console]::CursorVisible = $false
    try {
        while (-not [Console]::KeyAvailable) {
            $spinnerChar = $spinnerChars[$spinnerIndex]
            $fullText = "$spinnerChar $promptBase $spinnerChar"

            [Console]::SetCursorPosition($startLeft, $startTop)
            Write-Host $fullText -NoNewline

            Start-Sleep -Milliseconds 150
            $spinnerIndex = ($spinnerIndex + 1) % $spinnerChars.Length
        }

        # Clear spinner line after key press
        [Console]::SetCursorPosition($startLeft, $startTop)
        Write-Host (' ' * ($promptBase.Length + 4)) -NoNewline  # +4 for spinner chars + spaces
        [Console]::SetCursorPosition($startLeft, $startTop)
        [Console]::ReadKey($true) | Out-Null
    } finally {
        [Console]::CursorVisible = $true
    }
}
function ShowSystemSummary { # Displays system information to user
    Clear-Host
    Write-Host "==== System Info ====" -ForegroundColor White

    # General Info
    Write-Host (" GENERAL     ") -BackgroundColor DarkGray -ForegroundColor Cyan -NoNewline
    Write-Host (" Device Name: ") -NoNewline
    GetDeviceName
    Write-Host (" | S/N: ") -NoNewline
    GetSerialNumber
	Write-Host (" | Ran as: ") -NoNewline
    GetCurrentUserIdentity
	# General Info - line 2
	Write-Host "`n             " -BackgroundColor DarkGray -ForegroundColor Cyan -NoNewline
    Write-Host (" OS: ") -NoNewline
    GetWindowsVersion
    Write-Host " | Activation: " -NoNewLine
	GetWindowsActivationKey
	Write-Host ""

    # Network Info
    Write-Host (" NETWORK     ") -BackgroundColor DarkGray -ForegroundColor Cyan -NoNewline
    Write-Host (" MAC Address: ") -NoNewline
    GetHardwareMAC
    Write-Host (" | IPv4 Addr: ") -NoNewline
    GetIPv4Address
	# Network Info - line 2
	Write-Host "`n             " -BackgroundColor DarkGray -ForegroundColor Cyan -NoNewline
    Write-Host (" Domain: ") -NoNewline
    GetDomainStatus
    Write-Host (" | Connection: ") -NoNewline
    GetNetworkType
    Write-Host ""

    # Software Info
    Write-Host (" SOFTWARE    ") -BackgroundColor DarkGray -ForegroundColor Cyan -NoNewline
    Write-Host (" LTAgent ID: ") -NoNewline
    GetLTAgentID
    Write-Host (" | Crowdstrike: ") -NoNewline
    GetCrowdstrikeInstallStatus
    Write-Host (" | CloudRadial: ") -NoNewline
    GetCloudRadialInstallStatus
    Write-Host ""

    # Storage
    Write-Host "`n==== Storage ====" -ForegroundColor White
    GetStorageInfo

    # Bitlocker
    Write-Host "`n==== BitLocker ====" -ForegroundColor White
    GetBitlockerRecovery

    # Users
    Write-Host "`n==== Users ====" -ForegroundColor White
    ListAllUsersWithAdminStatus

    # Legend
	Write-Host "(`"" -NoNewLine; Write-Host "*" -ForegroundColor Cyan -NoNewline; Write-host "`" = `"You`")"
    # Exit
    Write-Host ""
    ShowExitSpinner
}

ShowSystemSummary

#CHANGELOG
# 0.0.0 - 5/3/25 - Created.
# 0.0.1 - 5/4/25 - Added TestAdmin and if statement to beginning to prompt user to re-run as admin, if not already done. Revised GetIPv4Address function to grab IPv4 specifically for the first adapter w Internet access. Added GetStorageInfo function. Added ShowExitSpinner function. Re-worked ShowSystemSummary function output. Various formatting tweaks.
# 0.0.2 - 5/6/25 - Updated GetWindowsVersion function to now check build, and if above 22000 report "11" instead of "10". Updated GetLTAgentID function so color is based off a .txt file indicative of installation, to portray when installed but no ID. Added GetCurrentUserIdentity function to display who ran script, with color to indicate admin. Added GetWindowsActivationKey function to display current Windows Activation Key. Revised ShowSystemSummary function's output to better accomodate smaller screens and additional information. Added comments, improved formatting.
