Clear-Host
$SpacegameVersion = "0.0.2"
# region ##### GAME INITIALIZER #####
function Start-NewGame {
    # Set the global start time for the survival clock
    $global:GameStartTime = Get-Date

##### PLAYER #####
    $global:Player = @{
        Credits    = 500
        HP         = 100
		MaxHP	   = 100
        Fuel       = 300
        MaxFuel    = 300
		MaxWeight  = 100
		System	   = $null
        Location   = "Mars"
        Dialog     = $null
		Message	   = $null
		Hyperdrive = $null # Unlocked by acquiring HyperDrive upgrade; allows for inter-galactic travel
		ProsGas	   = $null # Unlocked by acquiring Gas Giant Prospecting Drill; allows for prospecting Gas Giants
		ProsIce    = $null # Unlocked by acquiring Ice Giant Prospecting Drill; allows for prospecting Ice Giants
    }

    $global:Inventory = @{
        "Fuel Cell (Small)"   = 1
        "Shield Cell (Small)" = 1
		#"HeavyObject" = 1
    }

    # Initialize/Reset the Trader State (Prevents persistence after death)
    $global:TraderState = @{}
	
	##### Values for Resources #####
	$global:ResourceMaster = @{
        # --- Resources ---
		# Debug 
		"HeavyObject"      = @{ Value = 1000;Weight = 999; Rarity = "SuperRare"; Description = "Shit's heavy."; Consumable = $false }
        # Metals
		"Iron"             = @{ Value = 10;  Weight = 1; Rarity = "SuperCommon"; Description = "Raw Iron ore."; Consumable = $false }
		"ScrapMetal"       = @{ Value = 25;  Weight = 2; Rarity = "Common";      Description = "Salvaged hull plating."; Consumable = $false }
		"Copper"           = @{ Value = 30;  Weight = 1; Rarity = "Common";      Description = "Raw Copper ore."; Consumable = $false }
		"Nickel"           = @{ Value = 40;  Weight = 1; Rarity = "Common"; 	 Description = "Raw Nickel ore."; Consumable = $false }
		"Silver"           = @{ Value = 10;  Weight = 1; Rarity = "Rare"; 	 	 Description = "Raw Silver ore."; Consumable = $false }
		"Gold"			   = @{ Value = 250; Weight = 1; Rarity = "SuperRare"; 	 Description = "Raw Glistening Gold ore."; Consumable = $false }
		"Uranium"          = @{ Value = 150;  Weight = 1; Rarity = "SuperRare";  Description = "Raw Uranium ore. (spicy!)"; Consumable = $false }
		# Minerals 
        "Silicates"        = @{ Value = 10;  Weight = 1; Rarity = "SuperCommon"; Description = "Raw silicate minerals."; Consumable = $false }
        "Sulfur"           = @{ Value = 18;  Weight = 1; Rarity = "Common";      Description = "Crystalline sulfur."; Consumable = $false }
        "SulfuricAcid"     = @{ Value = 25;  Weight = 2; Rarity = "Common";      Description = "Corrosive chemical drums."; Consumable = $false }
		# Gases
		"Nitrogen"         = @{ Value = 12;  Weight = 1; Rarity = "Common";      Description = "Compressed nitrogen canisters."; Consumable = $false }
        "Hydrogen"         = @{ Value = 14;  Weight = 1; Rarity = "Common";      Description = "Hydrogen gas cylinders."; Consumable = $false }
		"Helium"           = @{ Value = 30;  Weight = 1; Rarity = "Rare";      	 Description = "Helium gas cylinders."; Consumable = $false }
		# Biological materials
        "Water"            = @{ Value = 10;  Weight = 1; Rarity = "SuperCommon"; Description = "Frozen H2O blocks."; Consumable = $false }
        "Biomass"          = @{ Value = 30;  Weight = 1; Rarity = "Rare";        Description = "Organic matter samples."; Consumable = $false }
		# Rarities / Artifiacts
		"MetallicHydrogen" = @{ Value = 250; Weight = 3; Rarity = "SuperRare";   Description = "Highly pressurized fuel precursor."; Consumable = $false }
		
		"Fossils"		   = @{ Value = 300; Weight = 1; Rarity = "SuperRare";  Description = "Unknown fossilzed alien lifeform."; Consumable = $false }

        # --- Consumables ---
        "Fuel Cell (Small)" 	= @{ Value = 25;  Weight = 1; Rarity = "Consumable";  Consumable = $true; Effect = "Fuel"; EffectValue = 25 ; Description = "A small emergency fuel cell.";  UseMessage = "+25% Fuel administered" }
		"Fuel Cell (Medium)"	= @{ Value = 50;  Weight = 2; Rarity = "Consumable";  Consumable = $true; Effect = "Fuel"; EffectValue = 50 ; Description = "A medium emergency fuel cell.";  UseMessage = "+50% Fuel administered" }
		"Fuel Cell (Large)"		= @{ Value = 75; Weight = 3; Rarity = "Consumable";  Consumable = $true; Effect = "Fuel"; EffectValue = 75 ; Description = "A large emergency fuel cell.";  UseMessage = "+75% Fuel administered" }
        "Shield Cell (Small)"   = @{ Value = 50;  Weight = 1; Rarity = "Consumable";  Consumable = $true; Effect = "HP"; EffectValue = 25 ; Description = "A small emergency shield restoration unit."; UseMessage = "+25% HP Restored" }
		"Shield Cell (Medium)"  = @{ Value = 100; Weight = 2; Rarity = "Consumable";  Consumable = $true; Effect = "HP"; EffectValue = 50 ; Description = "A medium emergency shield restoration unit."; UseMessage = "+50% HP Restored" }
        "Shield Cell (Large)"   = @{ Value = 150; Weight = 3; Rarity = "Consumable";  Consumable = $true; Effect = "HP"; EffectValue = 100 ; Description = "A large emergency shield restoration unit."; UseMessage = "+100% HP Restored" }

        # --- Upgrades ---
		# Stat Boosters
        "Cargo Baffles"    				= @{ Value = 500; Weight = 0; Rarity = "Upgrade";     Description = "Optimized storage racks."; Consumable = $true; Effect = "MaxWeight"; EffectValue = 25 }
		"Auxiliary Fuel Tank"  			= @{ Value = 500; Weight = 0; Rarity = "Upgrade";     Description = "Additional fuel capacity."; Consumable = $true; Effect = "MaxFuel"; EffectValue = 100 }
		"U.C.E. Shield Generator MK I"  = @{ Value = 250; Weight = 0; Rarity = "Upgrade";     Description = "Increased shield capacity."; Consumable = $true; Effect = "MaxHP"; EffectValue = 25 }
		"U.C.E. Shield Generator MK II" = @{ Value = 500; Weight = 0; Rarity = "Upgrade";     Description = "Increased shield capacity."; Consumable = $true; Effect = "MaxHP"; EffectValue = 50 }
		"U.C.E. Shield Generator MK III"= @{ Value = 750; Weight = 0; Rarity = "Upgrade";     Description = "Increased shield capacity."; Consumable = $true; Effect = "MaxHP"; EffectValue = 75 }
		"U.C.E. Shield Generator MK IV" = @{ Value = 1000; Weight = 0; Rarity = "Upgrade";    Description = "Increased shield capacity."; Consumable = $true; Effect = "MaxHP"; EffectValue = 100 }
		"U.C.E. Shield Generator MK V"  = @{ Value = 2000; Weight = 0; Rarity = "Upgrade";    Description = "Increased shield capacity."; Consumable = $true; Effect = "MaxHP"; EffectValue = 200 }
		# Gadgets
		#  -Gas Giant Drill
		#  -Ice Giant Drill 
	}
	
	##### Damage multipliers for Hazards #####
	$global:HazardMaster = @{
		# Universal / Low Severity
		"Hull stress"                = 0.2
		"Micro-vibrations"           = 0.5
		"Static discharge"           = 0.8
		"Atmospheric turbulence"     = 1.0

		# Moderate Severity
		"Tectonic shift"			 = 1.6
		"Solar flare radiation"      = 1.5
		"Acid rain corrosion"        = 1.8
		"Dust storm abrasion"        = 1.4
		"Extreme cold stress"        = 1.5
		"Gravity well shear"         = 1.8

		# High Severity
		"Ring shard impact"          = 3.0
		"Magma spray"                = 3.0
		"Lightning discharge"        = 2.5
		"Methane pressure spike"     = 2.5
		"Cryo-geyser eruption"       = 2.2
		"Supersonic wind shear"      = 2.0
		
		# Catastrophic Severity
		"Extreme Lightning discharge"= 5
		"Asteroid impact"			 = 4.5
		"Super-cyclone vortex"       = 4.2
		"Tectonic plate collapse"	 = 4
		
		# Catacylysmic Severity
		"Singularity"				 = 100
	}

    # Define rarity order for sorting logic
    $global:RarityOrder = @{
        "SuperCommon" = 1
        "Common"      = 2
        "Rare"        = 3
        "SuperRare"   = 4
        "Consumable"  = 5
        "Upgrade"     = 6
    }

	$global:SolSystem = @{
		_Metadata = @{ Name = "The Sol System" }
		# Terrestrial 
		Mercury  = @{ 
			Distance    = 0.4; Inhabited = $false; Type = "Terrestrial"; Hazard = 60; PlanetColor="DarkYellow"
			Description = "Mostly magma."
			Resources   = @{ "Iron" = 400; "Nickel" = 150; "Silicates" = 150; "Sulfur" = 100; "Gold" = 100; "Copper" = 100 }
			HazardReasons = @("Solar flare radiation", "Magma spray", "Hull stress", "Micro-vibrations", "Tectonic shift", "Tectonic plate collapse")
		}
		Venus    = @{ 
			Distance    = 0.7; Inhabited = $false; Type = "Terrestrial"; Hazard = 40; PlanetColor="Yellow"
			Description = "Very bright."
			Resources   = @{ "SulfuricAcid" = 400; "Nitrogen" = 200; "Sulfur" = 100; "Nickel" = 10; "Silver" = 200; "Gold" = 60 }
			HazardReasons = @("Acid rain corrosion", "Atmospheric turbulence", "Hull stress", "Static discharge", "Tectonic shift", "Tectonic plate collapse")
		}
		Earth    = @{ 
			Distance    = 1.0; Inhabited = $true;  Type = "Terrestrial"; Hazard = 20; PlanetColor="Green"
			Description = "Home?"
			Resources   = @{ "Water" = 400; "ScrapMetal" = 200; "Iron" = 113; "Copper" = 100; "Biomass" = 150; "Silver" = 20; "Uranium" = 10; "Gold"  = 5; "Fossils" = 2 }
			HazardReasons = @("Atmospheric turbulence", "Hull stress", "Micro-vibrations", "Static discharge", "Tectonic shift")
			TraderName="U.C.E.O.C.S."; TotalTraderCredits=5000; FuelModifier=1.2; RepairModifier=2.0
			Dialog=@{
				Greeting="Welcome to the United Countries of Earth orbital commerce services..."; TradeGreeting="How may I assist you today..."
				Refuel="Tanks topped."; Repair="Structural integrity restored."; Trade="Credits transfered."
				InsufficientFunds="Transaction denied."; InsufficientFundsTrader="You've surpassed your credit-limit. Try again later."
				Frustrated="What? No."
			}
						TraderStock = @{ 
				"Fuel Cell (Small)" = 3
				"Fuel Cell (Medium)" = 2
				"Fuel Cell (Large)" = 1
				"Shield Cell (Small)" = 3
				"Shield Cell (Medium)" = 2
				"Shield Cell (Large)" = 1
				"U.C.E. Shield Generator MK I" = 1
				"U.C.E. Shield Generator MK II" = 1
				"U.C.E. Shield Generator MK III" = 1
				"Auxiliary Fuel Tank" = 1
			}
		}
		Mars     = @{ 
			Distance    = 1.5; Inhabited = $true;  Type = "Terrestrial"; Hazard = 10; PlanetColor="DarkRed"
			Description = "The frontier."
			Resources   = @{ "Iron" = 500; "Silicates" = 300; "ScrapMetal" = 100; "Water" = 50; "Silver" = 50 }
			HazardReasons = @("Dust storm abrasion", "Static discharge", "Hull stress", "Micro-vibrations", "Tectonic shift")
			TraderName="Mars Colony"; TotalTraderCredits=3000; FuelModifier=1.0; RepairModifier=1.0
			Dialog=@{
				Greeting="Welcome back, scrapper."; TradeGreeting="What'll it be this time?"
				Refuel="Fuel's pumpin'."; Repair="Hull patched."; Trade="Pleasure doin' business."
				InsufficientFunds="Credits first, hero."; InsufficientFundsTrader="And what'll ya be wanting for that?."
				Frustrated="Come again, now?"
			}
			TraderStock = @{ 
				"Fuel Cell (Small)" = 3
				"Fuel Cell (Medium)" = 2
				"Fuel Cell (Large)" = 1
				"Shield Cell (Small)" = 3
				"Shield Cell (Medium)" = 2
				"Shield Cell (Large)" = 1
				"Cargo Baffles" = 1
				"Auxiliary Fuel Tank" = 1
			}
		}
		# Ceres
		Ceres    = @{ 
			Distance    = 2.8; Inhabited = $false; Type = "Asteroid";    Hazard = 35; PlanetColor="Gray"
			Description = "An abandoned rock."
			Resources   = @{ "Water" = 250; "Iron" = 250; "Silicates" = 200; "Nickel" = 80; "Silver" = 120; "Gold" = 100 }
			HazardReasons = @("Ring shard impact", "Micro-vibrations", "Hull stress", "Static discharge", "Asteroid impact")
		}
		# Jovian 
		Jupiter  = @{ 
			Distance    = 5.2; Inhabited = $false; Type = "Gas Giant";   Hazard = 80; PlanetColor="Red"
			Description = "Vast and hostile."
			Resources   = @{ "Hydrogen" = 500; "MetallicHydrogen" = 250; "Helium" = 200; "Nitrogen" = 50 }
			HazardReasons = @("Gravity well shear", "Solar flare radiation", "Hull stress", "Atmospheric turbulence", "Super-cyclone vortex")
		}
		Saturn   = @{ 
			Distance    = 9.5; Inhabited = $false; Type = "Gas Giant";   Hazard = 60; PlanetColor="Yellow"
			Description = "The ringed behemoth."
			Resources   = @{ "Hydrogen" = 500; "MetallicHydrogen" = 150; "Water" = 200; "Helium" = 100; "ScrapMetal" = 40; "Silicates" = 10 }
			HazardReasons = @("Ring shard impact", "Lightning discharge", "Hull stress", "Static discharge", "Super-cyclone vortex")
		}
		Uranus   = @{ 
			Distance    = 19.2; Inhabited = $false; Type = "Ice Giant";   Hazard = 50; PlanetColor="DarkCyan"
			Description = "The tilted giant."
			Resources   = @{ "Hydrogen" = 375; "MetallicHydrogen" = 125; "Water" = 300; "Nitrogen" = 100; "Uranium" = 100 }
			HazardReasons = @("Extreme cold stress", "Methane pressure spike", "Hull stress", "Micro-vibrations")
		}
		Neptune  = @{ 
			Distance    = 30.1; Inhabited = $false; Type = "Ice Giant";   Hazard = 75; PlanetColor="Blue"
			Description = "Deep blue."
			Resources   = @{ "Hydrogen" = 450; "MetallicHydrogen" = 200; "SulfuricAcid" = 200; "Nitrogen" = 125; "Water" = 25 }
			HazardReasons = @("Supersonic wind shear", "Extreme cold stress", "Hull stress", "Atmospheric turbulence")
		}
		Pluto    = @{ 
			Distance    = 39.5; Inhabited = $false; Type = "Dwarf";       Hazard = 20; PlanetColor="White"
			Description = "The icy underdog."
			Resources   = @{ "Water" = 350; "Nitrogen" = 300; "Biomass" = 100; "Silver" = 100; "Gold" = 100; "Fossils" = 50 }
			HazardReasons = @("Cryo-geyser eruption", "Extreme cold stress", "Hull stress", "Micro-vibrations", "Asteroid impact")
		}
		Haumea   = @{ 
			Distance    = 43.2; Inhabited = $false; Type = "Dwarf";       Hazard = 15; PlanetColor="Gray"
			Description = "Hi'iaka & Namaka"
			Resources   = @{ "Silicates" = 500; "ScrapMetal" = 100; "Silver" = 100; "Gold" = 100; "Copper" = 100; "Iron" = 50; "Nickel" = 50 }
			HazardReasons = @("Micro-vibrations", "Hull stress", "Static discharge", "Asteroid impact")
		}
		Makemake = @{ 
			Distance    = 45.5; Inhabited = $false; Type = "Dwarf";       Hazard = 15; PlanetColor="Gray"
			Description = "Red and cold."
			Resources   = @{ "Nitrogen" = 350; "Hydrogen" = 200; "Water" = 140; "Iron" = 75; "Nickel" = 75; "Silver" = 50; "Gold" = 50; "Copper" = 50; "Silicates" = 10 }
			HazardReasons = @("Extreme cold stress", "Hull stress", "Static discharge", "Asteroid impact")
		}
		Eris     = @{ 
			Distance    = 67.8; Inhabited = $false; Type = "Dwarf";       Hazard = 40; PlanetColor="Gray"
			Description = "Far-out..."
			Resources   = @{ "MetallicHydrogen" = 450; "ScrapMetal" = 450; "Gold" = 50; "Silver" = 50 }
			HazardReasons = @("Solar flare radiation", "Hull stress", "Micro-vibrations", "Asteroid impact")
		}
	}

	$global:CurrentSolarSystem = $global:SolSystem
    if ($CurrentSolarSystem.ContainsKey("_Metadata")) {
        $global:Player.System = $CurrentSolarSystem._Metadata.Name
    }
}

function Initialize-Trader($planetName) {
    $planet = $CurrentSolarSystem[$planetName]
    if (-not $planet.Inhabited) { return }
    if ($null -eq $global:TraderState) { $global:TraderState = @{} }

    if (-not $global:TraderState.ContainsKey($planetName)) {
        $global:TraderState[$planetName] = @{
            Stock        = $planet.TraderStock.Clone()
            Credits      = $planet.TotalTraderCredits
            LastTrade    = Get-Date
        }
    }
    else {
        $elapsed = (Get-Date) - $global:TraderState[$planetName].LastTrade
        if ($elapsed.TotalMinutes -ge 10) {
            $global:TraderState[$planetName].Stock     = $planet.TraderStock.Clone()
            $global:TraderState[$planetName].Credits   = $planet.TotalTraderCredits
            $global:TraderState[$planetName].LastTrade = Get-Date
        }
    }
}
#endregion

#region ##### UTILITIES #####
function Get-Clock { (Get-Date).AddYears(300).ToString("MM/dd/yyyy hh:mm:ss tt") }

function Get-CurrentWeight {
    $total = 0
    foreach ($name in $Inventory.Keys) {
        $itemMaster = $ResourceMaster[$name]
        $total += ($itemMaster.Weight * $Inventory[$name])
    }
    return $total
}

function Get-SurvivedTime {
    if (-not $global:GameStartTime) { return "0s" }
    $span = (Get-Date) - $global:GameStartTime
    $h = [math]::Floor($span.TotalHours)
    $m = $span.Minutes
    $s = $span.Seconds
    if ($h -gt 0) { return "{0}h {1}m {2}s" -f $h, $m, $s }
    if ($m -gt 0) { return "{0}m {1}s" -f $m, $s }
    return "{0}s" -f $s
}

function Get-PercentColor {
    param(
        [double]$Current, 
        [double]$Max, 
        [switch]$Inverted # If true, high percentage = Red (useful for Weight/Hazard)
    )
    if ($Max -le 0) { return "White" }
    $pct = ($Current / $Max) * 100

    if ($Inverted) {
        if ($pct -ge 91) { "DarkRed" }
        elseif ($pct -ge 76) { "Red" }
        elseif ($pct -ge 51) { "Yellow" }
        #elseif ($pct -ge 11) { "Green" }
        else { "Green" }
    } else {
        if ($pct -ge 51) { "Green" }
        elseif ($pct -ge 26) { "Yellow" }
        elseif ($pct -ge 11) { "Red" }
        else { "DarkRed" }
    }
}

<# Legacy mf
function Get-HPColor {
    param([int]$Value, [int]$UpBand=66, [int]$MidBand=33, [int]$LowBand=9, [string]$UpBandColor="Green", [string]$MidBandColor="Yellow", [string]$LowBandColor="Red", [string]$EmptyBandColor="DarkRed", [string]$zeroColor="DarkRed")
    if     ($Value -ge $UpBand)  { $UpBandColor }
    elseif ($Value -ge $MidBand) { $MidBandColor }
    elseif ($Value -ge $LowBand) { $LowBandColor }
    elseif ($Value -eq 0)        { $zeroColor }
    else                         { $EmptyBandColor }
}#>

function Get-HazardColor($Value) {
    if ($Value -ge 85) { "DarkRed" }
    elseif ($Value -ge 66) { "Red" }
    elseif ($Value -ge 33) { "Yellow" }
    elseif ($Value -eq 1 ) { "DarkCyan" }
    else { "Green" }
}

function Get-RarityColor($rarity) {
    switch ($rarity) {
        "SuperCommon" { "DarkGray" }
        "Common"      { "Gray" }
        "Rare"        { "Cyan" }
        "SuperRare"   { "Magenta" }
        "Consumable"  { "Green" }
        "Upgrade"     { "DarkGreen" }
    }
}

function Flash-DamageBackground {
    param(
        [scriptblock]$RedrawAction
    )
    # Store current color
    $originalColor = $host.UI.RawUI.BackgroundColor
    
    # Trigger Red Flash
    $host.UI.RawUI.BackgroundColor = "DarkRed"
    Clear-Host
    
    # Execute the redraw so the screen isn't empty during the flash
    if ($RedrawAction) { &$RedrawAction }
    
    Start-Sleep -Milliseconds 100
    
    # Revert to Black
    $host.UI.RawUI.BackgroundColor = "Black"
    Clear-Host

    # Re-execute the redraw immediately so the screen isn't empty after the flash
    if ($RedrawAction) { &$RedrawAction }
}

function Pause { Read-Host "Press Enter" | Out-Null }
#endregion

#region ##### Mechanics #####

function Prospect {
    $planetData = $CurrentSolarSystem[$Player.Location]
    $startTime = Get-Date
    $lastYieldTime = Get-Date
    $sessionLog = New-Object System.Collections.Generic.List[PSObject]
    $maxVisibleLines = 20
    
    $DrawUI = {
        Show-Header -Prospecting
        $elapsed = (Get-Date) - $startTime
        $cycleColor = if ($elapsed.Seconds % 2 -eq 0) { "Yellow" } else { "DarkYellow" }
        $planetNameColor = if ($planetData.PlanetColor) { $planetData.PlanetColor } else { "White" }

        Write-Host -NoNewline "   =>>> " -ForegroundColor $cycleColor
        Write-Host -NoNewline "PROSPECTING " -ForegroundColor DarkGray
        Write-Host -NoNewline $Player.Location.ToUpper() -ForegroundColor $planetNameColor
        Write-Host " <<<= " -ForegroundColor $cycleColor

        Write-Host -NoNewline "   Hazard Lvl: "
        Write-Host $planetData.Hazard -ForegroundColor (Get-HazardColor $planetData.Hazard)
        Write-Host ""

        for ($i = 0; $i -lt $maxVisibleLines; $i++) {
            if ($i -lt $sessionLog.Count) { 
                Write-Host "   $($sessionLog[$i].Text)" -ForegroundColor $sessionLog[$i].Color 
            } 
            else { Write-Host "" }
        }

        if ($sessionLog.Count -gt $maxVisibleLines) {
            $hiddenCount = $sessionLog.Count - $maxVisibleLines
            Write-Host "   ($hiddenCount more...)" -ForegroundColor DarkGray
        } else {
            Write-Host ""
        }
        
        Write-Host ""
        Write-Host -NoNewLine "   Prospecting for: "
        Write-Host "$($elapsed.ToString('mm\:ss'))" -ForegroundColor Cyan
        Write-Host -NoNewline "   Press "
        Write-Host -NoNewline "[ANY KEY]" -ForegroundColor DarkCyan
        Write-Host " to stop prospecting..."
    }

    while ($true) {
        &$DrawUI

        # Resource Tick (Every second)
        if (((Get-Date) - $lastYieldTime).TotalSeconds -ge 1) {
            $lastYieldTime = Get-Date

            if ($Player.Fuel -gt 0) {
                if ((Get-CurrentWeight) -lt $Player.MaxWeight) { 
                    $totalWeight = 0
                    foreach ($value in $planetData.Resources.Values) { $totalWeight += $value }
                    
                    # Roll 1-1000 for high-resolution rarity
                    $roll = Get-Random -Minimum 1 -Maximum 1001 

                    $cumulative = 0
                    $resName = $null
                    foreach ($kvp in $planetData.Resources.GetEnumerator()) {
                        $cumulative += $kvp.Value
                        if ($roll -le $cumulative) {
                            $resName = $kvp.Key
                            break
                        }
                    }

                    if ($resName) {
                        if ($Inventory.ContainsKey($resName)) { $Inventory[$resName]++ }
                        else { $Inventory[$resName] = 1 }
                        
                        $sessionLog.Insert(0, @{
                            Text  = "+1 $resName"
                            Color = (Get-RarityColor $ResourceMaster[$resName].Rarity)
                        })
                        $Player.Fuel = [math]::Max(0, $Player.Fuel - 1)
                    }
                }
                else {
                    $player.Message = "Cargo hull is full!"
                    break
                }
            }
            else { break }
        }

        # --- Balanced Hazard Logic ---
        $frequencyModifier = 0.35
        if ((Get-Random -Min 1 -Max 101) -le ($planetData.Hazard * $frequencyModifier)) {
            
            $reason = if ($planetData.HazardReasons) { $planetData.HazardReasons | Get-Random } else { "Hull stress" }
            $multiplier = if ($global:HazardMaster.ContainsKey($reason)) { $global:HazardMaster[$reason] } else { 1.0 }

            $baseDmg = Get-Random -Min 3 -Max 10
            $finalDmg = [int][math]::Max(1, ($baseDmg * $multiplier))
            
            $Player.HP -= $finalDmg
            $sessionLog.Insert(0, @{ Text = "-$finalDmg HP - $reason"; Color = "Red" })

            Flash-DamageBackground -RedrawAction $DrawUI
        }

        if ($Player.HP -le 0) { break }

        $exitLoop = $false
        for ($j = 0; $j -lt 10; $j++) {
            Start-Sleep -Milliseconds 100
            if ([Console]::KeyAvailable) { $null = [Console]::ReadKey($true); $exitLoop = $true; break }
        }
        if ($exitLoop) { break }
    }
}

function Add-Item {
    param([string]$ItemName, [int]$Qty = 1)
    if ($Inventory.ContainsKey($ItemName)) { $Inventory[$ItemName] += $Qty }
    else { $Inventory[$ItemName] = $Qty }
}

function Use-Item($ItemName) {
    if (-not $Inventory.ContainsKey($ItemName)) { return }
    $itemMaster = $ResourceMaster[$ItemName]
    if (-not $itemMaster.Consumable) { return }

    switch ($itemMaster.Effect) {
        "Fuel"      { $Player.Fuel = [Math]::Min($Player.MaxFuel, $Player.Fuel + $itemMaster.EffectValue) }
        "MaxFuel"   { $Player.MaxFuel += $itemMaster.EffectValue; $Player.Fuel += $itemMaster.EffectValue }
        "HP"        { $Player.HP   = [Math]::Min($player.MaxHP, $Player.HP   + $itemMaster.EffectValue) }
		"MaxHP"        { $Player.MaxHP += $itemMaster.EffectValue; $Player.HP += $itemMaster.EffectValue }
        "MaxWeight" { $Player.MaxWeight += $itemMaster.EffectValue }
    }

    if ($Inventory[$ItemName] -le 1) { $Inventory.Remove($ItemName) }
    else { $Inventory[$ItemName]-- }
    $Player.Message = "Used $ItemName."
}
#endregion 

#region ##### Menu functions #####
function Show-Header {
    param([switch]$Prospecting)
    Clear-Host
    $planetData = $CurrentSolarSystem[$Player.Location]
    $weight = Get-CurrentWeight
    
    # Credits
    Write-Host -BackgroundColor Black -NoNewline "CD="
    Write-Host -NoNewline $Player.Credits -ForegroundColor Yellow
    
    # HP (High = Good)
    Write-Host -BackgroundColor Black -NoNewline " | HP="
    $hpCol = Get-PercentColor -Current $Player.HP -Max $player.MaxHP
    Write-Host -BackgroundColor Black -NoNewline "$($Player.HP)" -ForegroundColor $hpCol
	Write-Host -BackgroundColor Black -NoNewline "/$($Player.MaxHP)"
    
    # Fuel (High = Good)
    #$fuelPercent = [int](($Player.Fuel / $Player.MaxFuel) * 100)
    Write-Host -BackgroundColor Black -NoNewline " | FL="
    $fuelCol = Get-PercentColor -Current $Player.Fuel -Max $Player.MaxFuel
    #Write-Host -NoNewline "$($fuelPercent)%" -ForegroundColor $fuelCol
    Write-Host -BackgroundColor Black -NoNewline " $($Player.Fuel)" -ForegroundColor $fuelCol
	Write-Host -BackgroundColor Black -NoNewline "/$($Player.MaxFuel)"
    
    # Weight (High = Bad/Inverted)
    Write-Host -BackgroundColor Black -NoNewline " | WT="
    $wtCol = Get-PercentColor -Current $weight -Max $Player.MaxWeight -Inverted
    Write-Host -BackgroundColor Black -NoNewline "$weight" -ForegroundColor $wtCol
    Write-Host -BackgroundColor Black -NoNewline "/$($Player.MaxWeight)" 
    
    # Orbit/System Info
    $label = if ($Prospecting) { "Prospecting: " } else { "Orbiting: " }
    Write-Host -BackgroundColor Black -NoNewline " | $label" 
    Write-Host -BackgroundColor Black -NoNewline $Player.Location -ForegroundColor ($planetData.PlanetColor)
	Write-Host -BackgroundColor Black -NoNewLine ", HZ="
	Write-Host -BackgroundColor Black -NoNewLine "$($PlanetData.Hazard)" -ForegroundColor (Get-HazardColor $planetData.Hazard)
    Write-Host -BackgroundColor Black " | $(Get-Clock)"

    # Status Messages
    if ($Player.Message) {
        Write-Host ""
        Write-Host "   $($Player.Message)" -ForegroundColor DarkGray
        $Player.Message = $null
    }

    if ($Player.LastLoot) {
        Write-Host ""
        Write-Host -NoNewline "   "
        Write-Host -NoNewline "+$($Player.LastLoot.Quantity) " -ForegroundColor Green
        Write-Host $Player.LastLoot.Name -ForegroundColor (Get-RarityColor $Player.LastLoot.Rarity)
        $Player.LastLoot = $null
    }

    if ($Player.Dialog) {
        Write-Host ""
        $PlanetColor = if ($planetData.Inhabited -and $planetData.ContainsKey("PlanetColor")) { $planetData.PlanetColor } else { "Gray" }
        Write-Host -NoNewline "> Incoming transmission from "
        Write-Host -NoNewline "$($planetData.TraderName)" -ForegroundColor $PlanetColor
        Write-Host ":"
        Write-Host -NoNewline "   `"" 
        Write-Host -NoNewline $Player.Dialog -ForegroundColor $PlanetColor
        Write-Host "`""
        $Player.Dialog = $null
    }
    Write-Host ""
}

function Show-Inventory {
    while ($true) {
        $inventoryWorth = 0
        $maxQtyLength = 1
        foreach ($name in $Inventory.Keys) { 
            $inventoryWorth += ($ResourceMaster[$name].Value * $Inventory[$name])
            $len = ($Inventory[$name]).ToString().Length
            if ($len -gt $maxQtyLength) { $maxQtyLength = $len }
        }
        
        Show-Header
        Write-Host "##### CARGO HOLD #####" -ForegroundColor Cyan
        Write-Host "Value: $inventoryWorth CD | Weight: $(Get-CurrentWeight)/$($Player.MaxWeight) kg"
        Write-Host ""
        Write-Host -NoNewline "[1] " -ForegroundColor Cyan; Write-Host "Back" -ForegroundColor DarkGray
        
        # Explicitly wrap in @() to ensure it's ALWAYS an array, even with 1 item
        $sortedKeys = @($Inventory.Keys | ForEach-Object {
            $m = $ResourceMaster[$_]
            [PSCustomObject]@{ Name = $_; RarityOrder = $global:RarityOrder[$m.Rarity]; Master = $m }
        } | Sort-Object RarityOrder, Name)

        $i = 2
        foreach ($item in $sortedKeys) {
            $qtyString = "x" + $Inventory[$item.Name]
            
            Write-Host -NoNewline "[$i] " -ForegroundColor Cyan
            Write-Host -NoNewline ($qtyString.PadRight($maxQtyLength + 2)) -ForegroundColor Cyan
            Write-Host -NoNewline ($item.Name.PadRight(15)) -ForegroundColor (Get-RarityColor $item.Master.Rarity)
			$desc = $item.Master.Description
            if ($item.Master.Effect) { Write-Host -NoNewline " | $desc"; Write-Host -NoNewline " (";Write-Host -NoNewline "$($item.Master.Rarity)" -ForegroundColor (Get-RarityColor $item.Master.Rarity); Write-Host ": +$($item.Master.EffectValue) $($item.Master.Effect))" }
			else { Write-Host -NoNewline " | $desc"; Write-Host -NoNewline "(";Write-Host -NoNewline "$($item.Master.Rarity)" -ForegroundColor (Get-RarityColor $item.Master.Rarity);Write-Host ")"} 
            $i++
        }
        
        $choice = Read-Host ">"
        if ($choice -eq "1") { return }
        if ($choice -as [int]) {
            $selection = [int]$choice
            $index = $selection - 2
            # Check count on the explicitly cast array
            if ($index -ge 0 -and $index -lt $sortedKeys.Count) {
                $selected = $sortedKeys[$index].Name
                if ($ResourceMaster[$selected].Consumable) { 
                    Use-Item $selected 
                } else {
                    $Player.Message = "$selected is not consumable."
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
        Write-Host -NoNewline "[1] " -ForegroundColor Cyan; Write-Host "Back" -ForegroundColor DarkGray
        Write-Host "[2] Buy" -ForegroundColor Cyan
        Write-Host "[3] Sell" -ForegroundColor Cyan
        $planetData = $CurrentSolarSystem[$planetName]
        $missingFuel = $Player.MaxFuel - $Player.Fuel
        $fuelPrice = [math]::Ceiling(($missingFuel * 0.5) * $planetData.FuelModifier)
        $missingHP = $Player.MaxHP - $Player.HP
        $repairPrice = [math]::Ceiling(($missingHP * 1.0) * $planetData.RepairModifier)
        $fuelColor = if ($Player.Credits -ge $fuelPrice) { "Green" } else { "Red" }
        $repairColor = if ($Player.Credits -ge $repairPrice) { "Green" } else { "Red" }
		Write-Host -NoNewline "[4] Repair - " -ForegroundColor Cyan; Write-Host -NoNewline "$repairPrice" -ForegroundColor $repairColor; Write-Host " CD" -ForegroundColor Cyan
		Write-Host -NoNewline "[5] Refuel - " -ForegroundColor Cyan; Write-Host -NoNewline "$fuelPrice" -ForegroundColor $fuelColor; Write-Host " CD" -ForegroundColor Cyan
        $choice = Read-Host ">"
        switch ($choice) {
            "1" { return }
            "2" { Show-BuyMenu }
            "3" { Show-SellMenu }
			"4" {
					if ($Player.HP -ge $Player.MaxHP) { $Player.Dialog=$planetData.Dialog.Frustrated } 
                    else {
						if ($Player.Credits -ge $repairPrice) {
							$Player.Credits -= $repairPrice; $Player.HP = $Player.MaxHP; $Player.Dialog=$planetData.Dialog.Repair
						} else { $Player.Dialog=$planetData.Dialog.InsufficientFunds }
					}
            }
			"5" {
					if ($Player.Fuel -ge $Player.MaxFuel) { $Player.Dialog=$planetData.Dialog.Frustrated } 
                    else {
						if ($Player.Credits -ge $fuelPrice) {
							$Player.Credits -= $fuelPrice; $Player.Fuel = $Player.MaxFuel; $Player.Dialog=$planetData.Dialog.Refuel
						} else { $Player.Dialog=$planetData.Dialog.InsufficientFunds }
					}
            }
        }
    }
}

function Show-BuyMenu {
    $planetName = $Player.Location
    Initialize-Trader $planetName
    $trader = $global:TraderState[$planetName]
    while ($true) {
		$Player.Message = "Buying from $($CurrentSolarSystem[$planetName].TraderName)"
        # Explicitly wrap in @() to fix "single item selection" bug
        $sortedStock = @($trader.Stock.Keys | ForEach-Object {
            $m = $ResourceMaster[$_]
            [PSCustomObject]@{ Name = $_; RarityOrder = $global:RarityOrder[$m.Rarity]; Master = $m }
        } | Sort-Object RarityOrder, Name)

        if ($null -eq $trader -or $sortedStock.Count -eq 0) { 
            $Player.Message = "Trader is out of stock."
            return 
        }
        $maxQtyLength = 1
        foreach ($name in $trader.Stock.Keys) {
            $len = ($trader.Stock[$name]).ToString().Length
            if ($len -gt $maxQtyLength) { $maxQtyLength = $len }
        }
        
        Show-Header
        Write-Host "Trader Wealth: $($trader.Credits) CD"
        Write-Host ""
        Write-Host -NoNewline "[1] " -ForegroundColor Cyan; Write-Host "Back" -ForegroundColor DarkGray
        
        $i = 2
        foreach ($item in $sortedStock) {
            $qtyString = "x" + $trader.Stock[$item.Name]
            $priceColor = if ($Player.Credits -ge $item.Master.Value) { "Green" } else { "Red" }
            
            # Dynamic Description with Effects
            $desc = $item.Master.Description
            if ($item.Master.Effect) {
                $desc = "$desc ($($item.Master.Rarity) - +$($item.Master.EffectValue) $($item.Master.Effect))"
            } else {
                $desc = "$desc ($($item.Master.Rarity))"
            }

            Write-Host -NoNewline "[$i] " -ForegroundColor Cyan
            Write-Host -NoNewline ("{0,5}" -f $item.Master.Value + " CD") -ForegroundColor $priceColor
            Write-Host -NoNewline " | "
            Write-Host -NoNewline ($qtyString.PadRight($maxQtyLength + 2)) -ForegroundColor Cyan
            Write-Host -NoNewline ($item.Name.PadRight(15)) -ForegroundColor (Get-RarityColor $item.Master.Rarity)
            $desc = $item.Master.Description
            if ($item.Master.Effect) { Write-Host -NoNewline " | $desc"; Write-Host -NoNewline " (";Write-Host -NoNewline "$($item.Master.Rarity)" -ForegroundColor (Get-RarityColor $item.Master.Rarity); Write-Host ": +$($item.Master.EffectValue) $($item.Master.Effect))" }
			else { Write-Host -NoNewline " | $desc"; Write-Host -NoNewline "(";Write-Host -NoNewline "$($item.Master.Rarity)" -ForegroundColor (Get-RarityColor $item.Master.Rarity);Write-Host ")"} 
            $i++
        }
        
        $input = Read-Host ">"
        if ($input -eq "1") { return }
        if ($input -as [int]) {
            $selection = [int]$input
            $index = $selection - 2
            if ($index -ge 0 -and $index -lt $sortedStock.Count) {
                $selectedName = $sortedStock[$index].Name
                $m = $ResourceMaster[$selectedName]
                $stockQty = $trader.Stock[$selectedName]
                
                $qty = 1
                if ($stockQty -gt 1) {
                    Write-Host -NoNewline "[?] Buy how many "
                    Write-Host -NoNewline "$selectedName" -ForegroundColor (Get-RarityColor $m.Rarity)
                    Write-Host " (A for all)?"
                    $qtyInput = Read-Host ">"
                    if ($qtyInput -match "^[aA]$") { $qty = $stockQty }
                    elseif ($qtyInput -as [int]) { $qty = [int]$qtyInput }
                    else { continue }
                }

                if ($qty -le 0 -or $qty -gt $stockQty) { continue }
                $totalCost = $m.Value * $qty
                if ($Player.Credits -lt $totalCost) { $Player.Dialog = $CurrentSolarSystem[$planetName].Dialog.InsufficientFunds; continue }
                
                $Player.Credits -= $totalCost
                $trader.Credits += $totalCost
                if ($trader.Stock[$selectedName] -le $qty) { $trader.Stock.Remove($selectedName) }
                else { $trader.Stock[$selectedName] -= $qty }
                Add-Item -ItemName $selectedName -Qty $qty
                $trader.LastTrade = Get-Date
                $Player.Dialog = $CurrentSolarSystem[$planetName].Dialog.Trade
            }
        }
    }
}

function Show-SellMenu {
    $planetName = $Player.Location
    Initialize-Trader $planetName
    $trader = $global:TraderState[$planetName]
    while ($true) {
		$Player.Message = "Selling to $($CurrentSolarSystem[$planetName].TraderName)"
        # Explicitly wrap in @() to fix "single item selection" bug
        $sortedInv = @($Inventory.Keys | ForEach-Object {
            $m = $ResourceMaster[$_]
            [PSCustomObject]@{ Name = $_; RarityOrder = $global:RarityOrder[$m.Rarity]; Master = $m }
        } | Sort-Object RarityOrder, Name)

        if ($null -eq $trader -or $sortedInv.Count -eq 0) { 
            $Player.Message = "Your cargo hold is empty."
            return 
        }
        $maxQtyLength = 1
        foreach ($name in $Inventory.Keys) {
            $len = ($Inventory[$name]).ToString().Length
            if ($len -gt $maxQtyLength) { $maxQtyLength = $len }
        }
        
        Show-Header
        Write-Host -NoNewline "Trader Wealth: "
        if ($trader.Credits -gt 3000) { Write-Host "$($trader.Credits)" -ForegroundColor Green } 
        elseif ($trader.Credits -gt 1000) { Write-Host "$($trader.Credits)" -ForegroundColor Yellow }
        else { Write-Host "$($trader.Credits)" -ForegroundColor Red }
        
        Write-Host -NoNewline "[1] " -ForegroundColor Cyan; Write-Host "Back" -ForegroundColor DarkGray
        
        $i = 2
        foreach ($item in $sortedInv) {
            $sellValue = [math]::Floor($item.Master.Value * 0.69)
            $priceColor = if ($trader.Credits -ge $sellValue) { "Green" } else { "Red" }
            $qtyString = "x" + $Inventory[$item.Name]

            # Dynamic Description with Effects
            $desc = $item.Master.Description
            if ($item.Master.Effect) {
                $desc = "$desc ($($item.Master.Rarity) - +$($item.Master.EffectValue) $($item.Master.Effect))"
            } else {
                $desc = "$desc ($($item.Master.Rarity))"
            }

            Write-Host -NoNewline "[$i] " -ForegroundColor Cyan
            Write-Host -NoNewline ("{0,5}" -f $sellValue + " CD") -ForegroundColor $priceColor
            Write-Host -NoNewline " | "
            Write-Host -NoNewline ($qtyString.PadRight($maxQtyLength + 2)) -ForegroundColor Cyan
            Write-Host -NoNewline ($item.Name.PadRight(15)) -ForegroundColor (Get-RarityColor $item.Master.Rarity)
            $desc = $item.Master.Description
            if ($item.Master.Effect) { Write-Host -NoNewline " | $desc"; Write-Host -NoNewline " (";Write-Host -NoNewline "$($item.Master.Rarity)" -ForegroundColor (Get-RarityColor $item.Master.Rarity); Write-Host ": +$($item.Master.EffectValue) $($item.Master.Effect))" }
			else { Write-Host -NoNewline " | $desc"; Write-Host -NoNewline "(";Write-Host -NoNewline "$($item.Master.Rarity)" -ForegroundColor (Get-RarityColor $item.Master.Rarity);Write-Host ")"} 
            $i++
        }
        
        $input = Read-Host ">"
        if ($input -eq "1") { return }
        if ($input -as [int]) {
            $selection = [int]$input
            $index = $selection - 2
            if ($index -ge 0 -and $index -lt $sortedInv.Count) {
                $selectedName = $sortedInv[$index].Name
                $m = $ResourceMaster[$selectedName]
                $playerQty = $Inventory[$selectedName]
                
                $qty = 1
                if ($playerQty -gt 1) {
                    Write-Host -NoNewline "[?] Sell how many "
                    Write-Host -NoNewline "$selectedName" -ForegroundColor (Get-RarityColor $m.Rarity)
                    Write-Host " (A for all)?"
                    $qtyInput = Read-Host ">"
                    if ($qtyInput -match "^[aA]$") { $qty = $playerQty }
                    elseif ($qtyInput -as [int]) { $qty = [int]$qtyInput }
                    else { continue }
                }

                if ($qty -le 0 -or $qty -gt $playerQty) { continue }
                $sellValue = [math]::Floor($m.Value * 0.69)
                $total = $sellValue * $qty
                if ($trader.Credits -lt $total) { 
                    $Player.Dialog = $CurrentSolarSystem[$planetName].Dialog.InsufficientFundsTrader
                    continue 
                }
                
                $Player.Credits += $total
                $trader.Credits -= $total
                if (-not $trader.Stock.ContainsKey($selectedName)) { $trader.Stock[$selectedName] = 0 }
                $trader.Stock[$selectedName] += $qty
                if ($Inventory[$selectedName] -le $qty) { $Inventory.Remove($selectedName) }
                else { $Inventory[$selectedName] -= $qty }
                $trader.LastTrade = Get-Date
                $Player.Dialog = $CurrentSolarSystem[$planetName].Dialog.Trade
            }
        }
    }
}

function Show-Death {
	# Calculate Total Value:
	$total=$Player.Credits
    foreach ($item in $Inventory.Keys) { $total += ($ResourceMaster[$item].Value * $Inventory[$item]) }
	
Write-Host "                      ..-%@@@@%-.:                   " -ForegroundColor DarkRed
Write-Host "                @@@@@@@@@@@@@@@@@@@@%:               " -ForegroundColor DarkRed
Write-Host "             =%############%@.@@@@@@@@@#             " -ForegroundColor DarkRed
Write-Host "          .##.. ============.%@@@%+@@@@@@@#:         " -ForegroundColor DarkRed
Write-Host "        .#..==:-.------------.===.#####@@@@##        " -ForegroundColor DarkRed -NoNewline;Write-Host "    >=>      >=>     >===>      >=>     >=>  " -ForegroundColor Red
Write-Host "       .#.=.--:.=============.--  .= *#######.       " -ForegroundColor DarkRed -NoNewline;Write-Host "     >=>    >=>    >=>    >=>   >=>     >=>  " -ForegroundColor Red
Write-Host "      -# =---.==@###########==.  +.--.=.##+####      " -ForegroundColor DarkRed -NoNewline;Write-Host "     >=>    >=>    >=>    >=>   >=>     >=>  " -ForegroundColor Red
Write-Host "      *- --.@@@############.   *====----:##*#-#      " -ForegroundColor DarkRed -NoNewline;Write-Host "        >=>      >=>        >=> >=>     >=>  " -ForegroundColor Red
Write-Host "      #=.-.@@@%#######         ####===---..#.=#.     " -ForegroundColor DarkRed -NoNewline;Write-Host "        >=>      >=>        >=> >=>     >=>  " -ForegroundColor Red
Write-Host "      =%=.:#@@@@@@##   #######   #####=.---.-#--+    " -ForegroundColor DarkRed -NoNewline;Write-Host "        >=>      >=>        >=> >=>     >=>  " -ForegroundColor Red
Write-Host "       +..@@#....@ #######@%##@   ####==----.-*.:    " -ForegroundColor DarkRed -NoNewline;Write-Host "        >=>        >=>     >=>  >=>     >=>  " -ForegroundColor Red
Write-Host "       %=#.-------.%#####.-----  ##@%#+=----- :#:*   " -ForegroundColor DarkRed -NoNewline;Write-Host "        >=>          >===>        >====>     " -ForegroundColor Red
Write-Host "       #.:+--------@@@.==----:  .---##%=-----.:..@@.@" -ForegroundColor DarkRed -NoNewline;Write-Host "                                             " -ForegroundColor Red
Write-Host "       --.=-------@@@@=#=--:  -. .---*#.-----+#:#@.@@" -ForegroundColor DarkRed -NoNewline;Write-Host "       >====>     >=> >=======> >====>       " -ForegroundColor Red
Write-Host "       -.#=+-----@.-@###--- ---- ----+#------+::###@*" -ForegroundColor DarkRed -NoNewline;Write-Host "       >=>   >=>  >=> >=>       >=>   >=>    " -ForegroundColor Red
Write-Host "        .#@.==+.#:--:####.  ---- -  .##-----::..####%" -ForegroundColor DarkRed -NoNewline;Write-Host "       >=>    >=> >=> >=>       >=>    >=>   " -ForegroundColor Red
Write-Host "       ####%#%###.---@##  @*:=-----. #%-----=.:#.%--:" -ForegroundColor DarkRed -NoNewline;Write-Host "       >=>    >=> >=> >=====>   >=>    >=>   " -ForegroundColor Red
Write-Host "      ..######+##.-:--@ #####@@@@@@% %#=..--#*-#--#-=" -ForegroundColor DarkRed -NoNewline;Write-Host "       >=>    >=> >=> >==       >=>    >=>   " -ForegroundColor Red
Write-Host "      .:#.====####--=--@###-#####-###   #=.-#+-#.--. " -ForegroundColor DarkRed -NoNewline;Write-Host "       >=>   >=>  >=> >=>       >=>   >=>    " -ForegroundColor Red
Write-Host "      # -----:.##+.#--@##########:## ##:--##.#.-.    " -ForegroundColor DarkRed -NoNewline;Write-Host "       >====>     >=> >=======> >====>       " -ForegroundColor Red
Write-Host "    ..+..---- ###%#######@#=.=. -..+ =:--##.#*==@.   " -ForegroundColor DarkRed
Write-Host "      #===.--*+*##@%%%@#:@#-- ---+--=--.##=###+.##.  " -ForegroundColor DarkRed -NoNewline;Write-Host -NoNewline "              Final Credits: ";Write-Host "$total" -ForegroundColor Yellow
Write-Host "      -#.==---.@:#.#=@.@. ++#+----==+--##.=#*##=:-.  " -ForegroundColor DarkRed -NoNewline;Write-Host -NoNewline "          Total Flight Time: ";Write-Host (Get-SurvivedTime) -ForegroundColor Cyan
Write-Host "    .@:#.-=--:*%..#=%.%#.-.+=---%+@@@#..####@.+:     " -ForegroundColor DarkRed
Write-Host "      +@=*#-:-+=##.-# ###.%-==+.@@@@--:##.#####..    " -ForegroundColor DarkRed
Write-Host "      ..@#-##.==.=%##%%##. #####.--=@@%.###%-#+.     " -ForegroundColor DarkRed  -NoNewline;Write-Host -NoNewline "               Game version: ";Write-Host $SpacegameVersion -ForegroundColor Green
Write-Host "      ==.@##=.############# --.##@@*:@@####.=+       " -ForegroundColor DarkRed
Write-Host "      #==.-- ########%%########.-.@@@@#%##.+         " -ForegroundColor DarkRed
Write-Host "       ==%.--------:...:---=%##+--:##.#==            " -ForegroundColor DarkRed
#Write-Host "                +:##...:---------.#%.##%.=.          " -ForegroundColor DarkRed
#Write-Host "                    =.-:.-+#######:-..               " -ForegroundColor DarkRed
    Pause
}

function Show-DistressSignal {
    Clear-Host
    Write-Host ""
    Write-Host "!!! EMERGENCY BEACON ACTIVATED !!!" -ForegroundColor DarkRed
    Write-Host "Signal broadcast in progress... standby for recovery." -ForegroundColor Red
    $seconds = 10 
    while ($seconds -gt 0) {
        $blink = if ($seconds % 2 -eq 0) { " [ SIGNAL PULSE ] " } else { " (             ) " }
        Show-Header
        Write-Host ""
        Write-Host "        $blink" -ForegroundColor DarkRed
        Write-Host ""
        Write-Host -NoNewline "   RESCUE ARRIVAL IN: " -ForegroundColor DarkYellow
		Write-Host -NoNewline "$seconds" -ForegroundColor Yellow
		Write-Host " SECONDS" -ForegroundColor DarkYellow
        Write-Host ""
        Write-Host "   !!! ALL RAW CARGO WILL BE FORFEIT !!!" -ForegroundColor DarkGray
        Write-Host "   !!! 50% CREDIT SURCHARGE APPLIED  !!!" -ForegroundColor DarkGray
        Start-Sleep -Seconds 1
        $seconds--
    }
    $Player.Credits = [math]::Floor($Player.Credits / 2)
    $keys = @($Inventory.Keys)
    foreach ($k in $keys) { if (-not $ResourceMaster[$k].Consumable) { $Inventory.Remove($k) } }
    $nearest = "Mars"; $minDist = 999; $currentDist = $CurrentSolarSystem[$Player.Location].Distance
    foreach ($key in $CurrentSolarSystem.Keys) {
        if ($key -ne "_Metadata" -and $CurrentSolarSystem[$key].Inhabited) {
            $dist = [math]::Abs($CurrentSolarSystem[$key].Distance - $currentDist)
            if ($dist -lt $minDist) { $minDist = $dist; $nearest = $key }
        }
    }
    $Player.Location = $nearest; $Player.Fuel = [math]::Min($Player.MaxFuel, 10); $Player.HP = 50   
    $Player.Dialog = "You were towed to orbit by a Scrapper Union vessel. Don't make them come out again."
}

function Show-SolarSystem {
    while ($true) {
        Show-Header
        if ($Player.System) { Write-Host "--- $($Player.System) ---" -ForegroundColor Green }
        Write-Host -NoNewline "[1]  Return to " -ForegroundColor Cyan
		Write-Host -NoNewline "$($Player.Location)" -ForegroundColor ($CurrentSolarSystem[$Player.Location].PlanetColor)
		Write-Host " orbit" -ForegroundColor Cyan
        
        $currentDist = $CurrentSolarSystem[$Player.Location].Distance
        $planetList = $CurrentSolarSystem.Keys | Where-Object { $_ -ne "_Metadata" } | ForEach-Object {
                $data = $CurrentSolarSystem[$_]
                [PSCustomObject]@{ Name = $_; DistFromSun = $data.Distance; DistFromPlayer = [math]::Abs($data.Distance - $currentDist); Data = $data }
            } | Sort-Object DistFromSun

        $i = 2; $canReachAnyOther = $false
		$maxNameLength = ($planetList.Name | Measure-Object -Property Length -Maximum).Maximum
		foreach ($entry in $planetList) {
			$planet = $entry.Name; $data = $entry.Data; $distanceAU = [math]::Round($entry.DistFromPlayer, 2)
			$fuelCost = [math]::Ceiling($distanceAU / 0.1)
            $remainingFuel = $Player.Fuel - $fuelCost
            $isCurrent = ($planet -eq $Player.Location)
            $fuelStatusColor = "DarkGray"
            
            if (-not $isCurrent) {
                if ($fuelCost -gt $Player.Fuel) { $fuelStatusColor = "DarkRed" }
                else {
                    $canReachAnyOther = $true
                    $remPct = ($remainingFuel / $Player.MaxFuel) * 100
                    if ($remPct -gt 50) { $fuelStatusColor = "Green" }
                    elseif ($remPct -ge 26) { $fuelStatusColor = "Yellow" }
                    else { $fuelStatusColor = "Red" }
                }
            }

			Write-Host -NoNewline ("[" + $i + "]").PadRight(5) -ForegroundColor Cyan
			# Planet Name in its PlanetColor
            Write-Host -NoNewline $planet.PadRight($maxNameLength + 1) -ForegroundColor ($data.PlanetColor)
            
            # Hazard Rating
            Write-Host -NoNewline "("
            Write-Host -NoNewline "$($data.Hazard) HZ" -ForegroundColor (Get-HazardColor $data.Hazard)
			if ($data.Hazard -ge 100) { Write-Host -NoNewline ")".PadRight(1) }
			elseif ($data.Hazard -ge 10) { Write-Host -NoNewline ")".PadRight(2) }
			else { Write-Host -NoNewline ")".PadRight(3) }
            
            # Distance Info
            Write-Host -NoNewline "| DIST "
			Write-Host -NoNewline ("{0:00.00}" -f $entry.DistFromPlayer) -ForegroundColor $fuelStatusColor
            Write-Host -NoNewline "AU ("
			Write-Host -NoNewline ("{0:000}" -f $fuelCost + " FL") -ForegroundColor $fuelStatusColor
            Write-Host -NoNewline ") | "
            
            # Type and Description
			$typeCol = switch($data.Type){ "Terrestrial"{"DarkYellow"};"Gas Giant"{"Yellow"};"Ice Giant"{"Cyan"};"Asteroid"{"DarkGray"};"Dwarf"{"DarkGray"};default{"Magenta"} }
            Write-Host -NoNewline $data.Type -ForegroundColor $typeCol
			Write-Host -NoNewLine " - $($data.Description)"
			if ($data.Inhabited) { Write-Host -NoNewline " ($($data.TraderName))" -ForegroundColor $data.PlanetColor }
			Write-Host ""
			$i++
		}
        
        $distressIndex = -1
        if (-not $canReachAnyOther) {
            $distressIndex = $i
            Write-Host -NoNewline "[$distressIndex] " -ForegroundColor Red
            Write-Host "Send Distress Signal" -ForegroundColor DarkRed
        }
        
        $choice = Read-Host ">"
        if ($choice -eq "1") { return }
        if ($distressIndex -ne -1 -and $choice -eq [string]$distressIndex) { Show-DistressSignal; return }
        if ($choice -match "^\d+$") {
            $index = [int]$choice
            if ($index -ge 2 -and $index -lt ($planetList.Count + 2)) {
                $selected = $planetList[$index - 2]
                if ($selected.Name -eq $Player.Location) { return }
                $fuelCost = [math]::Ceiling($selected.DistFromPlayer / 0.1)
                if ($fuelCost -le $Player.Fuel) {
                    $Player.Fuel -= $fuelCost; $Player.Location = $selected.Name
                    $Player.Dialog = if ($CurrentSolarSystem[$selected.Name].Inhabited) { $CurrentSolarSystem[$selected.Name].Dialog.Greeting } else { $null }
                    return
                }
            }
        }
    }
}

function Show-OrbitMenu {
    if ($Player.HP -le 0) { Show-Death; return "Death" }
    $planetData = $CurrentSolarSystem[$Player.Location]
    if ($planetData.Inhabited -and -not $Player.Dialog) { $Player.Dialog = $planetData.Dialog.Greeting }
    Show-Header
    Write-Host -NoNewline "[1] Depart " -ForegroundColor Cyan
    Write-Host $Player.Location -ForegroundColor ($planetData.PlanetColor)
    Write-Host "[2] Inventory" -ForegroundColor Cyan
    Write-Host "[3] Prospect" -ForegroundColor Cyan
    if ($planetData.Inhabited) { Write-Host "[4] Trade" -ForegroundColor Cyan }
	#Write-Host "[0] DEBUG Prospect"
    $choice = Read-Host ">"
    switch ($choice) {
        "1" { return "Depart" }
        "2" { return "Inventory" }
        "3" { return "Prospect" }
        "4" { $Player.Dialog=$planetData.Dialog.TradeGreeting ; if ($planetData.Inhabited) { return "Trade" } }
        #"0" { return "Debug" }
    }
    return $null
}

#endregion

#region ##### DO IT #####
while ($true) {
    Start-NewGame
    while ($true) {
        $action = Show-OrbitMenu
        if ($action -eq "Death") { break }
        switch ($action) {
            "Depart"    { Show-SolarSystem }
            "Inventory" { Show-Inventory }
            "Prospect"  { Prospect }
            "Trade"     { Show-TraderMenu }
            #"Debug"     { DEBUGProspect }
        }
    }
}
#endregion

# CHANGELOG
# 0.0.0 - 02/15/2026
# 0.0.1 - 02/19/2026 - Added a better death screen. Added damage backgroundcolor flashes. Revised Buy/Sell/Inv: No longer returns upon every selection, can now select final item, items now list their rarity and effects.Replaced Get-HPColor with Get-PercentColor for dynamic scaling. 
# 0.0.2 - 02/20/2026 - Added $HazardMaster and re-worked the HazardReasons and Prospect damage logic. Added buying from/selling to headers. Changed resources from 100to1000 collective value, and re-balanced prospecting. Re-balanced

# To add...
# New factions arent listed on Solar Menu until found.
# Quest mechanics (accepting/managing/completing) for unique rewards.
# Require GasGiant and IceGiant prospecting drill upgrades before they can be prospected. 
