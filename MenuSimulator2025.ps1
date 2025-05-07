# Menu Simulator 2025 - by Alexander DeMey - A customizable and easily expandable switch menu that navigates based on numberical user input. 

function Test-Admin { return ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator") }

function GetMachineInfo { # Runs my Machine_Info.ps1 from GitHub. Runs in memory if running as admin, runs from temp in new instance as admin if not running as admin.
    $scriptUrl = "https://raw.githubusercontent.com/thePijiN/AlexScripts/refs/heads/main/Machine_Info.ps1"

    function Test-Admin {
        return ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
    }

    if (Test-Admin) {
        # Already admin — run directly in memory
        try {
            Invoke-Expression (Invoke-WebRequest -Uri $scriptUrl -UseBasicParsing).Content
        } catch {
            Write-Host "Failed to run script from URL:" -ForegroundColor Red
            Write-Host $_.Exception.Message -ForegroundColor Yellow
        }
    } else {
        # Not admin — download to temp and elevate
        $tempScriptPath = Join-Path $env:TEMP "Machine_Info.ps1"
        try {
            Invoke-WebRequest -Uri $scriptUrl -UseBasicParsing -OutFile $tempScriptPath -ErrorAction Stop
            Start-Process powershell.exe -ArgumentList "-ExecutionPolicy Bypass -File `"$tempScriptPath`"" -Verb RunAs
        } catch {
            Write-Host "Failed to download or relaunch script:" -ForegroundColor Red
            Write-Host $_.Exception.Message -ForegroundColor Yellow
        }
    }
}

function ShowMenuOptions { # Lists menu $menuOptions to the user
    if ($MenuOptions.Count -gt 0) {
        # Output the first menu item
        $firstItem = $MenuOptions[0]
        Write-Host -NoNewline $firstItem[0] -ForegroundColor Green
        Write-Host -NoNewline $firstItem[1] -ForegroundColor Cyan
        Write-Host $firstItem[2] -ForegroundColor White
    }

    # Write the static [0] line as the second item
    Write-Host -NoNewline "[0] " -ForegroundColor Green
    Write-Host "Main Menu/Exit" -ForegroundColor Red

    # Output remaining menu items (if any)
    for ($i = 1; $i -lt $MenuOptions.Count; $i++) {
        $menuItem = $MenuOptions[$i]
        Write-Host -NoNewline $menuItem[0] -ForegroundColor Green
        Write-Host -NoNewline $menuItem[1] -ForegroundColor Cyan
        Write-Host $menuItem[2] -ForegroundColor White
    }
}

function RejectInvalidInput { # Simply informs the user their input was invalid
    Write-Host "Invalid selection. Try again.`n" -ForegroundColor Red
}

function Show-MainMenu { # The index. Present functions as menu options to user and accept input to navigate/execute.
    $bannerText = @'
*******************
Menu Simluator 2025
*******************
'@ # Define the Main Menu banner
    Write-Host $bannerText -Foregroundcolor green # Show the Main Menu banner
	if (!(Test-Admin)) { # Passive-aggressively bitch if the user isn't running as admin
		Write-Host "You're NOT running as admin, btw" -ForegroundColor Red
	}
	
	$MenuOptions = @( # Define Menu Options
		@("1.==", "==== MAIN MENU ====", "=============="),
		@("[1] ", "Enter first submenu", " - Description")
	)
    ShowMenuOptions # Display Menu Options
    $1MenuChoice = Read-Host "Input: `$1MenuChoice" # Accept user input as option selection
    if ($1MenuChoice -notmatch '^[0-9]+$') { RejectInvalidInput; return } # Reject any inputs that contains letters. (If the user inputs an invalid number, this is caught by the 'default' statement below)
    switch ([int]$1MenuChoice) {
        0 { Exit 0 }
        1 {
            while ($true) {
                $MenuOptions = @(
                    @("", "2.============HEADER======================", ""),
                    @("[1] ", "Enter the second submenu", " - Description")
                )
                ShowMenuOptions
                $2MenuChoice = Read-Host "Input `$2MenuChoice"
                if ($2MenuChoice -notmatch '^[0-9]+$') { RejectInvalidInput; continue }
                switch ([int]$2MenuChoice) {
                    0 { Clear-Host; return }
                    1 {
                        while ($true) {
                            $MenuOptions = @(
                                @("3.============HEADER=====================", "", ""),
                                @("[1] ", "Enter the third submenu", " - Description")
                            )
                            ShowMenuOptions
                            $3MenuChoice = Read-Host "Input: `$3MenuChoice"
                            if ($3MenuChoice -notmatch '^[0-9]+$') { RejectInvalidInput; continue }
                            switch ([int]$3MenuChoice) {
                                0 { Clear-Host; return }
                                1 {
                                    while ($true) {
                                        $MenuOptions = @(
                                            @("", "", "4.============HEADER======================"),
                                            @("[1] ", "Execute example function", " - Description")
                                        )
                                        ShowMenuOptions
                                        $4MenuChoice = Read-Host "Input: `$4MenuChoice"
                                        if ($4MenuChoice -notmatch '^[0-9]+$') { RejectInvalidInput; continue }
                                        switch ([int]$4MenuChoice) {
                                            0 { Clear-Host; return }
                                            1 { GetMachineInfo }
                                            default {
                                                RejectInvalidInput
                                            }
                                        }
                                    }
                                }
                                default {
                                    RejectInvalidInput
                                }
                            }
                        }
                    }
                    default {
                        RejectInvalidInput
                    }
                }
            }
        }
        default {
            RejectInvalidInput
        }
    }
}

# Now that all the functions and variables have been defined...
while ($true) { # This simply persists while the script does.
    Show-MainMenu # Show menu, until death.
}

# 0.0.0 - 5/7/25 - Release.