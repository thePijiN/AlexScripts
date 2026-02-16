Clear-Host

# region ##### GAME INITIALIZER #####
function Start-NewGame {

##### PLAYER #####
    $global:Player = @{
        Credits   = 1000
        HP        = 100
        Fuel      = 100
		MaxWeight = 100
		System	  = $null
        Location  = "Mars"
        Dialog    = $null
		DialogColor=$null
        LastLoot  = $null
    }

    $global:Inventory = @{
		"Fuel Cell" = @{
			Value       = 100
			Weight      = 5
			Description = "Standard emergency fuel cell. +33% fuel"
			Quantity    = 1
			Rarity      = "Common"
			Consumable  = $true
			Effect      = "Fuel"
			EffectValue = 33
		}
		"Shield Cell" = @{
			Value       = 150
			Weight      = 4
			Description = "Emergency shield restoration unit. +25% HP"
			Quantity    = 1
			Rarity      = "Common"
			Consumable  = $true
			Effect      = "HP"
			EffectValue = 25
		}
	}
	
	##### Values for Resources #####
	$global:ResourceValues = @{
		"Iron" = 20
		"Silicates" = 15
		"Sulfur" = 18
		"SulfuricAcid" = 25
		"Nitrogen" = 12
		"Water" = 10
		"Biomass" = 30
		"ScrapMetal" = 22
		"Hydrogen" = 14
		"MetallicHydrogen" = 200
	}

	$global:SolSystem = @{
		_Metadata = @{ Name = "The Sol System" }
		# --- INNER SYSTEM: SAFE & INDUSTRIAL ---
		Mercury  = @{ 
			Distance    = 0.4; Inhabited = $false; Type = "Terrestrial"; Hazard = 70
			Description = "Mostly magma."
			Resources   = @{ "Iron" = 60; "Silicates" = 30; "Sulfur" = 10 }
		}
		Venus    = @{ 
			Distance    = 0.7; Inhabited = $false; Type = "Terrestrial"; Hazard = 95
			Description = "Bright."
			Resources   = @{ "SulfuricAcid" = 70; "Nitrogen" = 20; "Sulfur" = 10 }
		}
		Earth    = @{ 
			Distance    = 1.0; Inhabited = $true;  Type = "Terrestrial"; Hazard = 10
			Description = "Home?"
			Resources   = @{ "Water" = 50; "Biomass" = 40; "ScrapMetal" = 10 }
			# Inhabited Planet
			TraderName="U.C.E.O.C.S."
			TotalTraderCredits=5000
			FuelModifier=1.2; RepairModifier=1.4
			DialogColor="DarkGreen"
			Dialog=@{
				Greeting="Welcome to the United Countries of Earth orbital commerce services..."
				Refuel="Tanks topped."
				Repair="Structural integrity restored."
				Trade="Credits transfered."
				InsufficientFunds="Transaction denied."
				InsufficientFundsTrader="You've surpassed your allotted credit-limit for now. Try again later."
				ProspectSuperCommon="Routine extraction."
				ProspectCommon="Acceptable yield."
				ProspectRare="Rare sample logged."
				ProspectSuperRare="Exceptional discovery."
				Frustrated="What? No."
			}
			TraderStock = @{
				"Fuel Cell" = @{
					Value       = 100
					Weight      = 5
					Description = "Standard emergency fuel cell."
					Quantity    = 3
					Rarity      = "Common"
					Consumable  = $true
					Effect      = "Fuel"
					EffectValue = 33
				}
				"Shield Cell" = @{
					Value       = 150
					Weight      = 4
					Description = "Emergency shield restoration unit."
					Quantity    = 2
					Rarity      = "Common"
					Consumable  = $true
					Effect      = "HP"
					EffectValue = 25
				}
			}
		}
		Mars     = @{ 
			Distance    = 1.5; Inhabited = $true;  Type = "Terrestrial"; Hazard = 1
			Description = "The frontier."
			Resources   = @{ "Iron" = 60; "Silicates" = 25; "ScrapMetal" = 10; "Water" = 5 }
			# Inhabited Planet 
			TraderName="Mars Colony"
			TotalTraderCredits=3000
			FuelModifier=1.0; RepairModifier=1.0
			DialogColor="DarkRed"
			Dialog=@{
				Greeting="Welcome back, scrapper. What'll it be this time?"
				Refuel="Fuel's pumpin'."
				Repair="Hull patched."
				Trade="Pleasure doin' business."
				InsufficientFunds="Credits first, hero."
				InsufficientFundsTrader="And what'll ya be wanting for that?."
				ProspectSuperCommon="Heh. Scrap's scrap."
				ProspectCommon="Not bad. That'll sell."
				ProspectRare="Oh? Now that's interesting."
				ProspectSuperRare="Where did you dig that up?"
				Frustrated="Come again, there?"
			}
			TraderStock = @{
				"Fuel Cell" = @{
					Value       = 100
					Weight      = 5
					Description = "Standard emergency fuel cell."
					Quantity    = 3
					Rarity      = "Common"
					Consumable  = $true
					Effect      = "Fuel"
					EffectValue = 33
				}
				"Shield Cell" = @{
					Value       = 150
					Weight      = 4
					Description = "Emergency shield restoration unit."
					Quantity    = 2
					Rarity      = "Common"
					Consumable  = $true
					Effect      = "HP"
					EffectValue = 25
				}
			}
		}
		Ceres    = @{ 
			Distance    = 2.8; Inhabited = $false; Type = "Asteroid";    Hazard = 5
			Description = "Abandoned."
			Resources   = @{ "Water" = 50; "Iron" = 30; "Silicates" = 20 }
		}

		# --- OUTER SYSTEM: HIGH-STAKES GAS & ICE ---
		Jupiter  = @{ 
			Distance    = 5.2; Inhabited = $false; Type = "Gas Giant";   Hazard = 100
			Description = "Vast and hostile."
			Resources   = @{ "Hydrogen" = 85; "Nitrogen" = 10; "MetallicHydrogen" = 5 }
		}
		Saturn   = @{ 
			Distance    = 9.5; Inhabited = $false; Type = "Gas Giant";   Hazard = 85
			Description = "Shit's blinged."
			Resources   = @{ "Hydrogen" = 60; "Water" = 30; "ScrapMetal" = 10 }
		}
		Uranus   = @{ 
			Distance    = 19.2; Inhabited = $false; Type = "Ice Giant";   Hazard = 50
			Description = "Shit shits."
			Resources   = @{ "Hydrogen" = 50; "Water" = 40; "Nitrogen" = 10 }
		}
		Neptune  = @{ 
			Distance    = 30.1; Inhabited = $false; Type = "Ice Giant";   Hazard = 55
			Description = "Shit's blue."
			Resources   = @{ "Hydrogen" = 70; "SulfuricAcid" = 20; "Nitrogen" = 10 }
		}

		# --- THE FRINGE: THE LONG HAUL ---
		Pluto    = @{ 
			Distance    = 39.5; Inhabited = $false; Type = "Dwarf";       Hazard = 20
			Description = "Shit's cold."
			Resources   = @{ "Water" = 50; "Nitrogen" = 40; "Biomass" = 10 }
		}
		Haumea   = @{ 
			Distance    = 43.2; Inhabited = $false; Type = "Dwarf";       Hazard = 15
			Description = "Shit's a brick."
			Resources   = @{ "Silicates" = 90; "ScrapMetal" = 10 }
		}
		Makemake = @{ 
			Distance    = 45.5; Inhabited = $false; Type = "Dwarf";       Hazard = 15
			Description = "Shit's tiny."
			Resources   = @{ "Nitrogen" = 80; "Hydrogen" = 20 }
		}
		Eris     = @{ 
			Distance    = 67.8; Inhabited = $false; Type = "Dwarf";       Hazard = 40
			Description = "Shit's far-out."
			Resources   = @{ "MetallicHydrogen" = 60; "ScrapMetal" = 30; "Biomass" = 10 }
		}
	}
	
	# Set the default Solar System 
	$global:CurrentSolarSystem = $global:SolSystem
	# Inherit system name from the CurrentSolarSystem metadata
    if ($CurrentSolarSystem.ContainsKey("_Metadata")) {
        $global:Player.System = $CurrentSolarSystem._Metadata.Name
    }
}

function Initialize-Trader($planetName) {
	# Initialize traderstate 
	$global:TraderState = @{}

    $planet = $CurrentSolarSystem[$planetName]

    if (-not $planet.Inhabited) { return }

    if (-not $TraderState.ContainsKey($planetName)) {

        $TraderState[$planetName] = @{
            Stock        = $planet.TraderStock.Clone()
            Credits      = $planet.TotalTraderCredits
            LastTrade    = Get-Date
        }
    }
    else {
        $elapsed = (Get-Date) - $TraderState[$planetName].LastTrade

        if ($elapsed.TotalMinutes -ge 10) {
            $TraderState[$planetName].Stock     = $planet.TraderStock.Clone()
            $TraderState[$planetName].Credits   = $planet.TotalTraderCredits
            $TraderState[$planetName].LastTrade = Get-Date
        }
    }
}

#endregion

#region ##### UTILITIES #####
function Get-Clock { (Get-Date).AddYears(300).ToString("MM/dd/yyyy hh:mm:ss tt") }

function Get-HPColor {
    param(
        [Parameter(Mandatory=$true, Position=0)]
        [int]$Value,
        [int]$UpBand    = 66,
        [int]$MidBand   = 33,
        [int]$LowBand   = 9,
		[string]$UpBandColor = "Green",
		[string]$MidBandColor = "Yellow",
		[string]$LowBandColor = "Red",
        [string]$EmptyBandColor = "DarkRed",
		[string]$zeroColor = "DarkRed"
    )

    if     ($Value -ge $UpBand)  { $UpBandColor }
    elseif ($Value -ge $MidBand) { $MidBandColor }
    elseif ($Value -ge $LowBand) { $LowBandColor }
	elseif ($Value -eq 0) 		 { $zeroColor }
    else                         { $EmptyBandColor }
}

function Get-HazardColor($Value) {
    if ($Value -ge 85) { "DarkRed" }
	elseif ($Value -ge 66) { "Red" }
    elseif ($Value -ge 33) { "Yellow" }
	elseif ($Value -eq 1 ) { "Cyan" }
    else { "Green" }
}

function Get-RarityColor($rarity) {
    switch ($rarity) {
        "SuperCommon" { "DarkGray" }
        "Common"      { "Gray" }
        "Rare"        { "Cyan" }
        "SuperRare"   { "Magenta" }
    }
}

function Show-Header {
	Clear-Host
    $planetData = $CurrentSolarSystem[$Player.Location]
	
	# Weight 
	$inventoryWeight = 0
	foreach ($key in $Inventory.Keys) {
		$inventoryWeight += ($Inventory[$key].Weight * $Inventory[$key].Quantity)
	}		
	# Display Header

    Write-Host -NoNewline "CD="
    Write-Host -NoNewline $Player.Credits -ForegroundColor Yellow
    Write-Host -NoNewline " | HP="
    Write-Host -NoNewline "$($Player.HP)%" -ForegroundColor (Get-HPColor $Player.HP)
    Write-Host -NoNewline " | FL="
    Write-Host -NoNewline "$($Player.Fuel)%" -ForegroundColor (Get-HPColor $Player.Fuel)
	Write-Host -NoNewline " | WT="
    $wtColor = Get-HPColor -value $inventoryWeight -UpBand 90 -UpBandColor "DarkRed" -MidBand 75 -MidBandColor "Red" -LowBand 50 -LowBandColor "Yellow" -EmptyBandColor "Green"
    Write-Host -NoNewline "$inventoryWeight" -ForegroundColor $wtColor
	Write-Host -NoNewline "/$($Player.MaxWeight)" 
    Write-Host -NoNewline " | Orbiting: "
    Write-Host -NoNewline $Player.Location -ForegroundColor (Get-HazardColor $planetData.Hazard)
    Write-Host " | $(Get-Clock)"

    if ($Player.LastLoot) {
        Write-Host ""
        Write-Host -NoNewline "   "
        Write-Host -NoNewline "+$($Player.LastLoot.Quantity) " -ForegroundColor Green
        Write-Host $Player.LastLoot.Name -ForegroundColor (Get-RarityColor $Player.LastLoot.Rarity)
		$Player.LastLoot = $null
    }

    if ($Player.Dialog) {
		Write-Host ""

		if ($planetData.Inhabited -and $planetData.ContainsKey("DialogColor")) {
			$dialogColor = $planetData.DialogColor
		}
		else {
			$dialogColor = "Gray"
		}

		Write-Host -NoNewline "> Incoming transmission from "
		Write-Host -NoNewline "$($planetData.TraderName)" -ForegroundColor $dialogColor
		Write-Host ":"
		Write-Host -NoNewline "   `"" 
		Write-Host -NoNewline $Player.Dialog -ForegroundColor $dialogColor
		Write-Host "`""

		$Player.Dialog = $null
	}
    Write-Host ""
}

function Pause { Read-Host "Press Enter" | Out-Null }
#endregion

#region ##### Mechanics #####
function Prospect {

    $planet = $CurrentSolarSystem[$Player.Location]

    if ($Player.Fuel -le 0) { return }

    $roll = Get-Random -Minimum 1 -Maximum 101
    $damageRoll = Get-Random -Minimum 1 -Maximum 101

    $cumulative = 0
    $found = $null

    foreach ($res in $planet.Resources.Keys) {
        $cumulative += $planet.Resources[$res]
        if ($roll -le $cumulative) {
            $found = $res
            break
        }
    }

    if (-not $found) { return }

    $bandSize = $planet.Resources[$found]

    if ($bandSize -ge 60)      { $rarity = "SuperCommon" }
    elseif ($bandSize -ge 30)  { $rarity = "Common" }
    elseif ($bandSize -ge 10)  { $rarity = "Rare" }
    else                       { $rarity = "SuperRare" }

    # Get value from global mapping
    $value = $ResourceValues[$found]

    if (-not $value) { $value = 5 }  # fallback safety

    $itemData = @{
        Value       = $value
        Weight      = 1
        Description = "Raw $found"
        Quantity    = 1
        Rarity      = $rarity
        Consumable  = $false
    }

    Add-Item -ItemName $found -ItemData $itemData -Source "Prospect"

    # Track loot for header display
    $Player.LastLoot = @{
        Name     = $found
        Quantity = 1
        Rarity   = $rarity
    }

    # Damage handling
    if ($damageRoll -le $planet.Hazard) {
        $damage = Get-Random -Minimum 5 -Maximum 16
        $Player.HP   = [math]::Max(0, $Player.HP - $damage)
        $Player.Fuel = [math]::Max(0, $Player.Fuel - 3)
    }
    else {
        $Player.Fuel = [math]::Max(0, $Player.Fuel - 1)
    }

	# Traders respond to prospecting based on obtained item rarity
	if ($planet.Inhabited -and $planet.Dialog) {

		$dialogKey = "Prospect$rarity"

		if ($planet.Dialog.ContainsKey($dialogKey)) {
			$Player.Dialog = $planet.Dialog[$dialogKey]
		}
	}
}

# INVENTORY ADD
function Add-Item {
    param(
        [string]$ItemName,
        [hashtable]$ItemData,
        [string]$Source  # Prospect | Buy | Sell
    )

    switch ($Source) {

        "Prospect" {
            if ($Inventory.ContainsKey($ItemName)) {
                $Inventory[$ItemName].Quantity++
            }
            else {
                $Inventory[$ItemName] = $ItemData
            }
        }

        "Buy" {
            if ($Player.Credits -lt $ItemData.Value) {
                return $false
            }

            $Player.Credits -= $ItemData.Value

            if ($Inventory.ContainsKey($ItemName)) {
                $Inventory[$ItemName].Quantity++
            }
            else {
                $Inventory[$ItemName] = $ItemData
            }

            return $true
        }

        "Sell" {
            if (-not $Inventory.ContainsKey($ItemName)) {
                return $false
            }

            $Player.Credits += $Inventory[$ItemName].Value

            if ($Inventory[$ItemName].Quantity -le 1) {
                $Inventory.Remove($ItemName)
            }
            else {
                $Inventory[$ItemName].Quantity--
            }

            return $true
        }
    }
}

# Consume Item
function Use-Item($ItemName) {

    if (-not $Inventory.ContainsKey($ItemName)) { return }

    $item = $Inventory[$ItemName]

    if (-not $item.Consumable) { return }

    switch ($item.Effect) {

        "Fuel" {
            $restore = $item.EffectValue
            $Player.Fuel = [Math]::Min(100, $Player.Fuel + $restore)
        }

        "HP" {
            $restore = $item.EffectValue
            $Player.HP = [Math]::Min(100, $Player.HP + $restore)
        }
    }

    # Reduce quantity
    if ($item.Quantity -le 1) {
        $Inventory.Remove($ItemName)
    }
    else {
        $Inventory[$ItemName].Quantity--
    }

    $Player.Dialog = "$ItemName used."
}
#endregion 

#region ##### Menu functions #####

function Show-Inventory { # INVENTORY MENU

	$inventoryWorth = 0
	foreach ($key in $Inventory.Keys) {
		$inventoryWorth += ($Inventory[$key].Value * $Inventory[$key].Quantity)
	}
	$inventoryWeight = 0
	foreach ($key in $Inventory.Keys) {
		$inventoryWeight += ($Inventory[$key].Weight * $Inventory[$key].Quantity)
	}

    while ($true) {
		# Get worth and weight totals of current inventory

		
        Show-Header
		Write-Host -NoNewline "##### "-ForegroundColor DarkYellow
		Write-Host -NoNewline "CARGO HOLD" -ForegroundColor Cyan
		Write-Host -NoNewline " #####"-ForegroundColor DarkYellow
		Write-Host -NoNewline " [ " -ForegroundColor Blue
		Write-Host -NoNewline " Total Value: "
		Write-Host -NoNewline "$inventoryWorth" -ForegroundColor Green 
		Write-Host -NoNewline "CD"
		Write-Host -NoNewline " | " -ForegroundColor Blue
		Write-Host -NoNewline " Total Weight: "
        $invWtColor = Get-HPColor -value $inventoryWeight -UpBand 90 -UpBandColor "DarkRed" -MidBand 75 -MidBandColor "Red" -LowBand 50 -LowBandColor "Yellow" -EmptyBandColor "Green"
		Write-Host -NoNewline "$inventoryWeight" -ForegroundColor $invWtColor
		Write-Host -NoNewline "kg"
		Write-Host " ] " -ForegroundColor Blue
		
        Write-Host -NoNewline "[1] " -ForegroundColor Cyan
		Write-Host "Back" -ForegroundColor DarkGray

        $i = 2
        $keys = @($Inventory.Keys)

        foreach ($name in $keys) {
            Write-Host -NoNewline "[$i] " -ForegroundColor Cyan
			Write-Host -NoNewline "$name"
			Write-Host -NoNewline " x$($Inventory[$name].Quantity)" -ForegroundColor Cyan
			Write-Host -NoNewline " [ " -ForegroundColor Blue
			# Value
			if ($Inventory[$name].Quantity -ge 2) { # Show value per/ea if quantity -ge 2
				$itemTotalWorth = ($Inventory[$name].Quantity * $Inventory[$name].Value)
				Write-Host -NoNewline "Value:"
				Write-Host -NoNewline "$itemTotalWorth" -ForegroundColor Green
				Write-Host -NoNewline "CD ("
				Write-Host -NoNewline "$($Inventory[$name].Value)" -ForegroundColor Green
				Write-Host -NoNewline "CD/ea)"
			} else { # Show value only if quantity -eq 1
				Write-Host -NoNewline "Value:"
				Write-Host -NoNewline "$($Inventory[$name].Value)" -ForegroundColor Green
				Write-Host -NoNewline "CD"
			}
			Write-Host -NoNewline " | "-ForegroundColor Blue
			# Weight 
            $itemWtColor = Get-HPColor -value $inventoryWeight -UpBand 90 -UpBandColor "DarkRed" -MidBand 75 -MidBandColor "Red" -LowBand 50 -LowBandColor "Yellow" -EmptyBandColor "Green"
			if ($Inventory[$name].Quantity -ge 2) { # Show weight per/ea if quantity -ge 2
				$itemTotalWeight = ($Inventory[$name].Quantity * $Inventory[$name].Weight)
				Write-Host -NoNewline "WT:"
				Write-Host -NoNewline "$itemTotalWeight" -ForegroundColor $itemWtColor
				Write-Host -NoNewline " ("
				Write-Host -NoNewline "$($Inventory[$name].weight)" -ForegroundColor $itemWtColor
				Write-Host -NoNewline "kg/ea)"
			} else { # Show weight only if quantity -eq 1
				Write-Host -NoNewline "WT:"
				Write-Host -NoNewline "$($Inventory[$name].weight)" -ForegroundColor $itemWtColor
				Write-Host -NoNewline "kg"
			}
			Write-Host " ]" -ForegroundColor Blue
            $i++
        }

        $choice = Read-Host ">"

        if ($choice -eq "1") { return }

        if ($choice -match "^\d+$") {

            $index = [int]$choice

            if ($index -ge 2 -and $index -lt ($keys.Count + 2)) {

                $selected = $keys[$index - 2]
                $itemData = $Inventory[$selected]

                Show-Header
                Write-Host $itemData.Description
                Write-Host ""

                if ($itemData.Consumable) {

                    Write-Host -NoNewline "[1] " -ForegroundColor Cyan
					Write-Host "Back" -ForegroundColor DarkGray
                    Write-Host "[2] Use"

                    $subChoice = Read-Host "Select"

                    if ($subChoice -eq "2") {
                        Use-Item $selected
                        return
                    }
                }
                else {
                    Pause
                }
            }
        }
    }
}

function Show-TraderMenu {

    $planetName = $Player.Location
    Initialize-Trader $planetName

    while ($true) {

        Show-Header
        Write-Host -NoNewline "[1] " -ForegroundColor Cyan
		Write-Host "Back" -ForegroundColor DarkGray
        Write-Host "[2] Buy" -ForegroundColor Cyan
        Write-Host "[3] Sell" -ForegroundColor Cyan
		
        $planetData = $CurrentSolarSystem[$planetName]
        $missingFuel = 100 - $Player.Fuel
        $fuelPrice = [math]::Ceiling(($missingFuel * 0.5) * $planetData.FuelModifier)
        $missingHP = 100 - $Player.HP
        $repairPrice = [math]::Ceiling(($missingHP * 1.0) * $planetData.RepairModifier)
        $fuelColor = if ($Player.Credits -ge $fuelPrice) { "Green" } else { "Red" }
        $repairColor = if ($Player.Credits -ge $repairPrice) { "Green" } else { "Red" }

		Write-Host -NoNewline "[4] Repair - " -ForegroundColor Cyan
		Write-Host -NoNewline "$repairPrice" -ForegroundColor $repairColor
		Write-Host "CD"
		
		Write-Host -NoNewline "[5] Refuel - " -ForegroundColor Cyan
		Write-Host -NoNewline "$fuelPrice" -ForegroundColor $fuelColor
		Write-Host "CD"

        $choice = Read-Host ">"

        switch ($choice) {
            "1" { return }
            "2" { Show-BuyMenu }
            "3" { Show-SellMenu }
			"4" {
                if ($planetData.Inhabited) {
					if ($Player.HP -eq 100) {
						$Player.Dialog=$planetData.Dialog.Frustrated
					} else {
						if ($Player.Credits -ge $repairPrice) {
							$Player.Credits -= $repairPrice
							$Player.HP = 100
							$Player.Dialog=$planetData.Dialog.Repair
						} else {
							$Player.Dialog=$planetData.Dialog.InsufficientFunds
						}
					}
                }
            }
			"5" {
                if ($planetData.Inhabited) {
					if ($Player.Fuel -eq 100) {
						$Player.Dialog=$planetData.Dialog.Frustrated
					} else {
						if ($Player.Credits -ge $fuelPrice) {
							$Player.Credits -= $fuelPrice
							$Player.Fuel = 100
							$Player.Dialog=$planetData.Dialog.Refuel
						} else {
							$Player.Dialog=$planetData.Dialog.InsufficientFunds
						}
					}
                }
            }
        }
    }
}

function Show-BuyMenu {

    $planetName = $Player.Location
    Initialize-Trader $planetName
    $trader = $TraderState[$planetName]

    while ($true) {

        Show-Header
        Write-Host "Trader Wealth: $($trader.Credits)"
        Write-Host ""
        Write-Host -NoNewline "[1] " -ForegroundColor Cyan
		Write-Host "Back" -ForegroundColor DarkGray

        $i = 2
        $items = @($trader.Stock.Keys)

        foreach ($name in $items) {

            $item = $trader.Stock[$name]
            $priceColor = if ($Player.Credits -ge $item.Value) { "Green" } else { "Red" }

            $priceText = "{0,5}" -f $item.Value
            $nameLabel = $name.PadRight(15).Substring(0,15)
            $rarityColor = Get-RarityColor $item.Rarity

            Write-Host -NoNewline "[$i] " -ForegroundColor Cyan
            Write-Host -NoNewline "$priceText CD" -ForegroundColor $priceColor
            Write-Host -NoNewline " | "
            Write-Host -NoNewline $nameLabel -ForegroundColor $rarityColor
            Write-Host -NoNewline " x$($item.Quantity)" -ForegroundColor Cyan
            Write-Host " | $($item.Description)"

            $i++
        }

        $input = Read-Host ">"

        if ($input -eq "1") { return }

        if ($input -match "^\d+$") {

            $index = [int]$input

            if ($index -ge 2 -and $index -lt ($items.Count + 2)) {

                $selected = $items[$index - 2]
                $item = $trader.Stock[$selected]

                Write-Host "[?] How many?"
                $qtyInput = Read-Host ">"

                if ($qtyInput -match "^[aA]$") {
                    $qty = $item.Quantity
                }
                elseif ($qtyInput -match "^\d+$") {
                    $qty = [int]$qtyInput
                }
                else {
                    $Player.Dialog = $CurrentSolarSystem[$planetName].Dialog.InsufficientFunds
                    continue
                }

                if ($qty -le 0 -or $qty -gt $item.Quantity) {
                    $Player.Dialog = $CurrentSolarSystem[$planetName].Dialog.InsufficientFunds
                    continue
                }

                $totalCost = $item.Value * $qty

                if ($Player.Credits -lt $totalCost) {
                    $Player.Dialog = $CurrentSolarSystem[$planetName].Dialog.InsufficientFunds
                    continue
                }

                $Player.Credits -= $totalCost
                $trader.Credits += $totalCost
                $item.Quantity -= $qty

                if ($item.Quantity -le 0) {
                    $trader.Stock.Remove($selected)
                }

                for ($x=0; $x -lt $qty; $x++) {
                    Add-Item -ItemName $selected -ItemData $item -Source "Prospect"
                }

                $trader.LastTrade = Get-Date
            }
        }
    }
}
function Show-SellMenu {

    $planetName = $Player.Location
    Initialize-Trader $planetName
    $trader = $TraderState[$planetName]

    while ($true) {

        Show-Header
        Write-Host -NoNewline "Trader Wealth: "
		if ($trader.Credits -gt 3000) { Write-Host "$($trader.Credits)" -ForegroundColor Green } 
		elseif ($trader.Credits -gt 1000) { Write-Host "$($trader.Credits)" -ForegroundColor Yellow }
		else { Write-Host "$($trader.Credits)" -ForegroundColor Red }
		
        Write-Host -NoNewline "[1] " -ForegroundColor Cyan
		Write-Host "Back" -ForegroundColor DarkGray

        $i = 2
        $items = @($Inventory.Keys)

        foreach ($name in $items) {

            $item = $Inventory[$name]
            $sellValue = [math]::Floor($item.Value * 0.69)
            $priceColor = if ($trader.Credits -ge $sellValue) { "Green" } else { "Red" }

            $priceText = "{0,5}" -f $sellValue
            $nameLabel = $name.PadRight(15).Substring(0,15)
            $rarityColor = Get-RarityColor $item.Rarity

            Write-Host -NoNewline "[$i] " -ForegroundColor Cyan
            Write-Host -NoNewline "$priceText CD" -ForegroundColor $priceColor
            Write-Host -NoNewline " | "
            Write-Host -NoNewline $nameLabel -ForegroundColor $rarityColor
            Write-Host -NoNewline " x$($item.Quantity)" -ForegroundColor Cyan
            Write-Host " | $($item.Description)"

            $i++
        }

        $input = Read-Host ">"

        if ($input -eq "1") { return }

        if ($input -match "^\d+$") {

            $index = [int]$input

            if ($index -ge 2 -and $index -lt ($items.Count + 2)) {

                $selected = $items[$index - 2]
                $item = $Inventory[$selected]

                Write-Host -NoNewline "[?] How many "
				Write-Host -NoNewline "$selected" -ForegroundColor $rarityColor
				Write-Host "?"
                $qtyInput = Read-Host ">"

                if ($qtyInput -match "^[aA]$") {
                    $qty = $item.Quantity
                }
                elseif ($qtyInput -match "^\d+$") {
                    $qty = [int]$qtyInput
                }
                else {
                    $Player.Dialog = "Impossible"
                    continue
                }

                if ($qty -le 0 -or $qty -gt $item.Quantity) {
                    $Player.Dialog = "Trader cannot afford that."
                    continue
                }

                $sellValue = [math]::Floor($item.Value * 0.69)
                $total = $sellValue * $qty

                if ($trader.Credits -lt $total) {
                    $Player.Dialog = "Trader cannot afford that."
                    continue
                }

                $Player.Credits += $total
                $trader.Credits -= $total

                if (-not $trader.Stock.ContainsKey($selected)) {
                    $trader.Stock[$selected] = $item.Clone()
                    $trader.Stock[$selected].Quantity = 0
                }

                $trader.Stock[$selected].Quantity += $qty

                if ($item.Quantity -le $qty) {
                    $Inventory.Remove($selected)
                }
                else {
                    $Inventory[$selected].Quantity -= $qty
                }

                $trader.LastTrade = Get-Date
            }
        }
    }
}
function Show-Death {

    Clear-Host
    Write-Host ""
    Write-Host "##    ##  ######  ##    ##     ######  ## ####### ###### " -ForegroundColor Red
    Write-Host " ##  ##  ##    ## ##    ##     ##   ## ## ##      ##   ##" -ForegroundColor Red
    Write-Host "  ####   ##    ## ##    ##     ##   ## ## #####   ##   ##" -ForegroundColor Red
    Write-Host "   ##    ##    ## ##    ##     ##   ## ## ##      ##   ##" -ForegroundColor Red
    Write-Host "   ##     ######   ######      ######  ## ####### ###### " -ForegroundColor Red
    Write-Host ""

    $total=$Player.Credits

    foreach ($item in $Inventory.Keys) {
        $total += ($Inventory[$item].Value * $Inventory[$item].Quantity)
    }

    Write-Host "Final Credits: $total" -ForegroundColor Yellow
    Write-Host ""
    Pause
	Exit
}

function Show-DistressSignal {
    Clear-Host
    Write-Host ""
    Write-Host "!!! EMERGENCY BEACON ACTIVATED !!!" -ForegroundColor DarkRed
    Write-Host "Signal broadcast in progress... standby for recovery." -ForegroundColor Red
    Write-Host ""
    
    $seconds = 10 # Reduced for testing/playability, set to 60 for tension
    while ($seconds -gt 0) {
        $blink = if ($seconds % 2 -eq 0) { " [ SIGNAL PULSE ] " } else { " (             ) " }
        
        Show-Header
        Write-Host ""
        Write-Host "        $blink" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "   RESCUE ARRIVAL IN: $seconds SECONDS" -ForegroundColor Yellow
        Write-Host ""
        Write-Host "   !!! ALL RAW CARGO WILL BE FORFEIT !!!" -ForegroundColor DarkGray
        Write-Host "   !!! 50% CREDIT SURCHARGE APPLIED  !!!" -ForegroundColor DarkGray
        
        Start-Sleep -Seconds 1
        $seconds--
    }

    # Apply Penalties
    $Player.Credits = [math]::Floor($Player.Credits / 2)
    
    $keys = @($Inventory.Keys)
    foreach ($k in $keys) {
        if (-not $Inventory[$k].Consumable) {
            $Inventory.Remove($k)
        }
    }

    $nearest = "Mars" 
    $minDist = 999
    $currentDist = $CurrentSolarSystem[$Player.Location].Distance

    foreach ($key in $CurrentSolarSystem.Keys) {
        if ($key -ne "_Metadata" -and $CurrentSolarSystem[$key].Inhabited) {
            $dist = [math]::Abs($CurrentSolarSystem[$key].Distance - $currentDist)
            if ($dist -lt $minDist) {
                $minDist = $dist
                $nearest = $key
            }
        }
    }

    $Player.Location = $nearest
    $Player.Fuel = 10 
    $Player.HP = 50   
    $Player.Dialog = "You were towed to orbit by a Scrapper Union vessel. Don't make them come out again."
}

# -------------------------------
# SOLAR MENU
# -------------------------------
function Show-SolarSystem {

    while ($true) {

        Show-Header
		
        if ($Player.System) {
            Write-Host "--- $($Player.System) ---" -ForegroundColor Green
        }
		
        Write-Host -NoNewline "[1]  Return to " -ForegroundColor Cyan
		Write-Host -NoNewline "$($Player.Location)" -ForegroundColor (Get-HazardColor $($CurrentSolarSystem[$Player.Location].Hazard))
		Write-Host " orbit" -ForegroundColor Cyan

        $currentDist = $CurrentSolarSystem[$Player.Location].Distance

        $planetList = $CurrentSolarSystem.Keys |
            Where-Object { $_ -ne "_Metadata" } |
            ForEach-Object {
                $data = $CurrentSolarSystem[$_]
                $distFromPlayer = [math]::Abs($data.Distance - $currentDist)
                [PSCustomObject]@{
                    Name           = $_
                    DistFromSun    = $data.Distance
                    DistFromPlayer = $distFromPlayer
                    Data           = $data
                }
            } |
            Sort-Object DistFromSun

        $i = 2
        $canReachAnyOther = $false

		$maxNameLength = ($planetList.Name | Measure-Object -Property Length -Maximum).Maximum
		foreach ($entry in $planetList) {
			$planet = $entry.Name
			$data = $entry.Data
			$distanceAU = [math]::Round($entry.DistFromPlayer, 2)
			
			$distanceText = "{0:00.00}" -f $distanceAU 
			
			$fuelCost = [math]::Ceiling($distanceAU / 0.1)
            $fuelPercentCost = [math]::Min(100, $fuelCost) 
            
            $remainingFuel = $Player.Fuel - $fuelCost
            
            $isCurrent = ($planet -eq $Player.Location)
            
            # Fuel Color Coding Logic
            $fuelStatusColor = "DarkRed" # Default
            if ($isCurrent) {
                $fuelStatusColor = "DarkGray"
            }
            elseif ($fuelCost -gt $Player.Fuel) {
                $fuelStatusColor = "DarkRed"
            }
            else {
                $canReachAnyOther = $true # You can reach a DIFFERENT planet
                if ($remainingFuel -gt 50) { $fuelStatusColor = "Green" }
                elseif ($remainingFuel -ge 26) { $fuelStatusColor = "Yellow" }
                else { $fuelStatusColor = "Red" }
            }

            # PS5.1 Compatibility: Extract color logic to variables before Write-Host
            $distColor = if ($isCurrent) { "DarkGray" } else { $fuelStatusColor }

			$indexText = "[$i]".PadRight(5)
			Write-Host -NoNewline $indexText -ForegroundColor Cyan
			
			$planetLabel = $planet.PadRight($maxNameLength)
			Write-Host -NoNewline $planetLabel -ForegroundColor (Get-HazardColor $data.Hazard)
            Write-Host -NoNewline " | "

			Write-Host -NoNewline "$distanceText" -ForegroundColor $distColor
            Write-Host -NoNewline "AU ("
            $fuelDisplay = "{0:000}" -f $fuelPercentCost
            Write-Host -NoNewline "$fuelDisplay%" -ForegroundColor $distColor
            Write-Host -NoNewline ") | "
			
			if ($data.Type -eq "Terrestrial") {Write-Host -NoNewline "Terrestrial" -ForegroundColor DarkYellow} 
			elseif ($data.Type -eq "Gas Giant") {Write-Host -NoNewline "Gas Giant" -ForegroundColor Yellow}
			elseif ($data.Type -eq "Ice Giant") {Write-Host -NoNewline "Ice Giant" -ForegroundColor Cyan}
			elseif ($data.Type -eq "Asteroid") {Write-Host -NoNewline "Asteroid" -ForegroundColor DarkGray}
			elseif ($data.Type -eq "Dwarf") {Write-Host -NoNewline "Dwarf" -ForegroundColor DarkGray}
			else {
				Write-Host -NoNewline "Other" -ForegroundColor Magenta
			}

            if ($data.Inhabited) {
                Write-Host -NoNewline " ($($data.TraderName))" -ForegroundColor $data.DialogColor
            }

			Write-Host " - $($data.Description)"

			$i++
		}

        # Distress Signal logic: Only if you CANNOT reach any OTHER planet.
        $distressIndex = -1
        if (-not $canReachAnyOther) {
            $distressIndex = $i
            Write-Host -NoNewline "[$distressIndex] " -ForegroundColor Red
            Write-Host "Send Distress Signal" -ForegroundColor DarkRed
        }

        $choice = Read-Host ">"

        if ($choice -eq "1") { return }
        
        if ($distressIndex -ne -1 -and $choice -eq [string]$distressIndex) {
            Show-DistressSignal
            return
        }

        if ($choice -match "^\d+$") {

            $index = [int]$choice

            if ($index -ge 2 -and $index -lt ($planetList.Count + 2)) {

                $selected = $planetList[$index - 2]
                $target = $selected.Name
                
                if ($target -eq $Player.Location) { return }

                $distanceAU = $selected.DistFromPlayer
                $fuelCost = [math]::Ceiling($distanceAU / 0.1)

                if ($fuelCost -le $Player.Fuel) {
                    $Player.Fuel -= $fuelCost
                    $Player.Location = $target
                    if ($CurrentSolarSystem[$target].Inhabited) {
                        $Player.Dialog = $CurrentSolarSystem[$target].Dialog.Greeting
                    }
                    else {
                        $Player.Dialog = $null
                    }
                    return
                }
            }
        }
    }
}
# ===============================
# ORBIT MENU
# ===============================
function Show-OrbitMenu {

    while ($true) {

        if ($Player.HP -le 0) { Show-Death }

        $planetData=$CurrentSolarSystem[$Player.Location]

        if ($planetData.Inhabited -and -not $Player.Dialog) {
            $Player.Dialog=$planetData.Dialog.Greeting
        }

        Show-Header

        Write-Host -NoNewline "[1] Depart " -ForegroundColor Cyan
		Write-Host $Player.Location -ForegroundColor (Get-HazardColor $planetData.Hazard)
        Write-Host "[2] Inventory" -ForegroundColor Cyan
        Write-Host "[3] Prospect" -ForegroundColor Cyan

        if ($planetData.Inhabited) {
			Write-Host "[4] Trade" -ForegroundColor Cyan
        }

        $choice=Read-Host ">"

        switch ($choice) {
            "1" { Show-SolarSystem }
            "2" { Show-Inventory }
            "3" { Prospect }
			"4" { if ($planetData.Inhabited) { Show-TraderMenu } }
        }
    }
}
#endregion

#region ##### DO IT #####
Start-NewGame
Show-OrbitMenu
#endregion