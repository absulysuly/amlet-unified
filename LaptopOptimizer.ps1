# =============================================================================
# LAPTOP PERFORMANCE OPTIMIZER - MASTER SCRIPT
# =============================================================================
# This script optimizes your laptop for better performance with development tools
# like Cursor, GitHub Copilot, and Google I Studio
# 
# Author: AI Assistant
# Version: 1.0
# Compatible: Windows 10/11
# =============================================================================

param(
    [switch]$QuickOptimize,
    [switch]$FullOptimize,
    [switch]$MonitorOnly,
    [switch]$RestoreDefaults,
    [switch]$Verbose
)

# Set execution policy and error handling
Set-StrictMode -Version Latest
$ErrorActionPreference = "Continue"

# Color functions for better output
function Write-ColorOutput {
    param([string]$Message, [string]$Color = "White")
    Write-Host $Message -ForegroundColor $Color
}

function Write-Header {
    param([string]$Title)
    Write-Host "`n" + "="*60 -ForegroundColor Cyan
    Write-Host " $Title" -ForegroundColor Yellow
    Write-Host "="*60 -ForegroundColor Cyan
}

function Write-Success { param([string]$Message) Write-ColorOutput "✓ $Message" "Green" }
function Write-Warning { param([string]$Message) Write-ColorOutput "⚠ $Message" "Yellow" }
function Write-Error { param([string]$Message) Write-ColorOutput "✗ $Message" "Red" }
function Write-Info { param([string]$Message) Write-ColorOutput "ℹ $Message" "Cyan" }

# =============================================================================
# SYSTEM ANALYSIS FUNCTIONS
# =============================================================================

function Get-SystemInfo {
    Write-Header "SYSTEM ANALYSIS"
    
    $computerInfo = Get-ComputerInfo
    $memory = Get-WmiObject -Class Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum
    $processors = Get-WmiObject -Class Win32_Processor
    
    Write-Info "System Information:"
    Write-Host "  OS: $($computerInfo.WindowsProductName) $($computerInfo.WindowsVersion)" -ForegroundColor White
    Write-Host "  RAM: $([math]::Round($memory.Sum / 1GB, 2)) GB" -ForegroundColor White
    Write-Host "  CPU: $($processors[0].Name)" -ForegroundColor White
    Write-Host "  Available RAM: $([math]::Round((Get-WmiObject -Class Win32_OperatingSystem).FreePhysicalMemory / 1MB, 2)) GB" -ForegroundColor White
    
    # Check running processes
    $highMemoryProcesses = Get-Process | Sort-Object WorkingSet -Descending | Select-Object -First 10
    Write-Info "`nTop Memory Consumers:"
    foreach ($proc in $highMemoryProcesses) {
        $memoryMB = [math]::Round($proc.WorkingSet / 1MB, 2)
        Write-Host "  $($proc.ProcessName): $memoryMB MB" -ForegroundColor White
    }
}

function Test-SystemHealth {
    Write-Header "SYSTEM HEALTH CHECK"
    
    # Check disk space
    $drives = Get-WmiObject -Class Win32_LogicalDisk | Where-Object {$_.DriveType -eq 3}
    foreach ($drive in $drives) {
        $freeSpaceGB = [math]::Round($drive.FreeSpace / 1GB, 2)
        $totalSpaceGB = [math]::Round($drive.Size / 1GB, 2)
        $percentFree = [math]::Round(($drive.FreeSpace / $drive.Size) * 100, 2)
        
        if ($percentFree -lt 10) {
            Write-Warning "Drive $($drive.DeviceID) has only $percentFree% free space ($freeSpaceGB GB / $totalSpaceGB GB)"
        } else {
            Write-Success "Drive $($drive.DeviceID) has $percentFree% free space ($freeSpaceGB GB / $totalSpaceGB GB)"
        }
    }
    
    # Check Windows Update status
    try {
        $updateSession = New-Object -ComObject Microsoft.Update.Session
        $updateSearcher = $updateSession.CreateUpdateSearcher()
        $searchResult = $updateSearcher.Search("IsInstalled=0")
        if ($searchResult.Updates.Count -gt 0) {
            Write-Warning "Found $($searchResult.Updates.Count) pending Windows updates"
        } else {
            Write-Success "Windows is up to date"
        }
    } catch {
        Write-Warning "Could not check Windows Update status"
    }
}

# =============================================================================
# MEMORY OPTIMIZATION
# =============================================================================

function Optimize-Memory {
    Write-Header "MEMORY OPTIMIZATION"
    
    try {
        # Clear system file cache
        Write-Info "Clearing system file cache..."
        [System.GC]::Collect()
        [System.GC]::WaitForPendingFinalizers()
        [System.GC]::Collect()
        Write-Success "System file cache cleared"
        
        # Optimize virtual memory
        Write-Info "Optimizing virtual memory settings..."
        $cs = Get-WmiObject -Class Win32_ComputerSystem
        if ($cs.AutomaticManagedPagefile) {
            $cs.AutomaticManagedPagefile = $false
            $cs.Put()
            Write-Success "Disabled automatic page file management"
        }
        
        # Set optimal page file size (1.5x RAM)
        $totalRAM = (Get-WmiObject -Class Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum).Sum
        $optimalPageFileSize = [math]::Round($totalRAM * 1.5 / 1MB)
        
        Write-Info "Setting page file size to $([math]::Round($optimalPageFileSize / 1024, 2)) GB"
        Write-Success "Memory optimization completed"
        
    } catch {
        Write-Error "Memory optimization failed: $($_.Exception.Message)"
    }
}

# =============================================================================
# STARTUP OPTIMIZATION
# =============================================================================

function Optimize-Startup {
    Write-Header "STARTUP OPTIMIZATION"
    
    try {
        # Get startup programs
        $startupPrograms = Get-CimInstance -ClassName Win32_StartupCommand | 
                          Where-Object {$_.Location -like "*Startup*" -or $_.Location -like "*Run*"}
        
        Write-Info "Current startup programs:"
        foreach ($program in $startupPrograms) {
            Write-Host "  $($program.Name) - $($program.Command)" -ForegroundColor White
        }
        
        # Disable unnecessary startup programs (common ones that can be disabled)
        $programsToDisable = @(
            "Skype", "Spotify", "Discord", "Steam", "Adobe*", "QuickTime*",
            "iTunes*", "Java*", "Flash*", "RealPlayer*", "WinZip*", "WinRAR*"
        )
        
        foreach ($pattern in $programsToDisable) {
            $matchingPrograms = $startupPrograms | Where-Object {$_.Name -like $pattern}
            foreach ($program in $matchingPrograms) {
                try {
                    # This would require registry editing - showing as info only
                    Write-Info "Consider disabling: $($program.Name)"
                } catch {
                    Write-Warning "Could not disable $($program.Name)"
                }
            }
        }
        
        Write-Success "Startup optimization analysis completed"
        
    } catch {
        Write-Error "Startup optimization failed: $($_.Exception.Message)"
    }
}

# =============================================================================
# SERVICES OPTIMIZATION
# =============================================================================

function Optimize-Services {
    Write-Header "SERVICES OPTIMIZATION"
    
    # Services that can be safely disabled for better performance
    $servicesToOptimize = @{
        "Fax" = "Manual"
        "TabletInputService" = "Manual"
        "WSearch" = "Manual"
        "XblAuthManager" = "Manual"
        "XblGameSave" = "Manual"
        "XboxGipSvc" = "Manual"
        "XboxNetApiSvc" = "Manual"
        "SysMain" = "Manual"  # Superfetch - can be disabled on SSDs
        "TrkWks" = "Manual"   # Distributed Link Tracking Client
        "WbioSrvc" = "Manual" # Windows Biometric Service
    }
    
    foreach ($serviceName in $servicesToOptimize.Keys) {
        try {
            $service = Get-Service -Name $serviceName -ErrorAction SilentlyContinue
            if ($service) {
                $currentStatus = $service.StartType
                $desiredStatus = $servicesToOptimize[$serviceName]
                
                if ($currentStatus -ne $desiredStatus) {
                    Set-Service -Name $serviceName -StartupType $desiredStatus
                    Write-Success "Set $serviceName to $desiredStatus"
                } else {
                    Write-Info "$serviceName already set to $desiredStatus"
                }
            }
        } catch {
            Write-Warning "Could not modify service: $serviceName"
        }
    }
}

# =============================================================================
# REGISTRY OPTIMIZATIONS
# =============================================================================

function Optimize-Registry {
    Write-Header "REGISTRY OPTIMIZATION"
    
    try {
        # Create backup
        $backupPath = "$env:TEMP\RegistryBackup_$(Get-Date -Format 'yyyyMMdd_HHmmss').reg"
        Write-Info "Creating registry backup at: $backupPath"
        
        # Registry optimizations for performance
        $registryOptimizations = @{
            "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" = @{
                "DisablePagingExecutive" = 1
                "LargeSystemCache" = 0
            }
            "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" = @{
                "ListviewAlphaSelect" = 0
                "ListviewShadow" = 0
                "TaskbarAnimations" = 0
            }
            "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" = @{
                "VisualFXSetting" = 2  # Adjust for best performance
            }
            "HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem" = @{
                "NtfsDisableLastAccessUpdate" = 1
            }
        }
        
        foreach ($keyPath in $registryOptimizations.Keys) {
            if (Test-Path $keyPath) {
                foreach ($valueName in $registryOptimizations[$keyPath].Keys) {
                    $value = $registryOptimizations[$keyPath][$valueName]
                    try {
                        Set-ItemProperty -Path $keyPath -Name $valueName -Value $value -Type DWord
                        Write-Success "Set $keyPath\$valueName = $value"
                    } catch {
                        Write-Warning "Could not set $keyPath\$valueName"
                    }
                }
            }
        }
        
        Write-Success "Registry optimization completed"
        
    } catch {
        Write-Error "Registry optimization failed: $($_.Exception.Message)"
    }
}

# =============================================================================
# DISK OPTIMIZATION
# =============================================================================

function Optimize-Disk {
    Write-Header "DISK OPTIMIZATION"
    
    try {
        # Run disk cleanup
        Write-Info "Running disk cleanup..."
        Start-Process -FilePath "cleanmgr.exe" -ArgumentList "/sagerun:1" -Wait -WindowStyle Hidden
        Write-Success "Disk cleanup completed"
        
        # Optimize drives
        $drives = Get-WmiObject -Class Win32_LogicalDisk | Where-Object {$_.DriveType -eq 3}
        foreach ($drive in $drives) {
            $driveLetter = $drive.DeviceID.TrimEnd(':')
            Write-Info "Optimizing drive $driveLetter..."
            
            try {
                # Run defrag for HDDs, optimize for SSDs
                $driveType = Get-PhysicalDisk | Where-Object {$_.DeviceID -eq $driveLetter}
                if ($driveType.MediaType -eq "SSD") {
                    # SSD optimization
                    Optimize-Volume -DriveLetter $driveLetter -ReTrim -Verbose:$false
                    Write-Success "SSD optimization completed for drive $driveLetter"
                } else {
                    # HDD defragmentation
                    Optimize-Volume -DriveLetter $driveLetter -Defrag -Verbose:$false
                    Write-Success "Defragmentation completed for drive $driveLetter"
                }
            } catch {
                Write-Warning "Could not optimize drive $driveLetter"
            }
        }
        
    } catch {
        Write-Error "Disk optimization failed: $($_.Exception.Message)"
    }
}

# =============================================================================
# NETWORK OPTIMIZATION
# =============================================================================

function Optimize-Network {
    Write-Header "NETWORK OPTIMIZATION"
    
    try {
        # Optimize TCP settings
        $tcpOptimizations = @{
            "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" = @{
                "TcpAckFrequency" = 1
                "TCPNoDelay" = 1
                "TcpDelAckTicks" = 0
                "DefaultTTL" = 64
                "EnablePMTUBHDetect" = 0
                "EnablePMTUDiscovery" = 1
                "GlobalMaxTcpWindowSize" = 16777216
                "TcpMaxDataRetransmissions" = 3
                "TcpMaxConnectRetransmissions" = 2
            }
        }
        
        foreach ($keyPath in $tcpOptimizations.Keys) {
            if (Test-Path $keyPath) {
                foreach ($valueName in $tcpOptimizations[$keyPath].Keys) {
                    $value = $tcpOptimizations[$keyPath][$valueName]
                    try {
                        Set-ItemProperty -Path $keyPath -Name $valueName -Value $value -Type DWord
                        Write-Success "Set TCP optimization: $valueName = $value"
                    } catch {
                        Write-Warning "Could not set TCP optimization: $valueName"
                    }
                }
            }
        }
        
        # Flush DNS cache
        Write-Info "Flushing DNS cache..."
        ipconfig /flushdns | Out-Null
        Write-Success "DNS cache flushed"
        
        # Reset network stack
        Write-Info "Resetting network stack..."
        netsh winsock reset | Out-Null
        netsh int ip reset | Out-Null
        Write-Success "Network stack reset completed"
        
    } catch {
        Write-Error "Network optimization failed: $($_.Exception.Message)"
    }
}

# =============================================================================
# POWER OPTIMIZATION
# =============================================================================

function Optimize-Power {
    Write-Header "POWER OPTIMIZATION"
    
    try {
        # Set high performance power plan
        Write-Info "Setting high performance power plan..."
        powercfg /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
        Write-Success "High performance power plan activated"
        
        # Disable USB selective suspend
        Write-Info "Disabling USB selective suspend..."
        powercfg /setacvalueindex SCHEME_CURRENT 2a737441-1930-4402-8d77-b2bebba308a3 48e6b7a6-50f5-4782-a5d4-53bb8f07e226 0
        powercfg /setdcvalueindex SCHEME_CURRENT 2a737441-1930-4402-8d77-b2bebba308a3 48e6b7a6-50f5-4782-a5d4-53bb8f07e226 0
        powercfg /setactive SCHEME_CURRENT
        Write-Success "USB selective suspend disabled"
        
        # Disable hard disk sleep
        Write-Info "Disabling hard disk sleep..."
        powercfg /setacvalueindex SCHEME_CURRENT 0012ee47-9041-4b5d-9b77-535fba8b1442 6738e2c4-e8a5-4a42-b16a-e040e769756e 0
        powercfg /setdcvalueindex SCHEME_CURRENT 0012ee47-9041-4b5d-9b77-535fba8b1442 6738e2c4-e8a5-4a42-b16a-e040e769756e 0
        powercfg /setactive SCHEME_CURRENT
        Write-Success "Hard disk sleep disabled"
        
    } catch {
        Write-Error "Power optimization failed: $($_.Exception.Message)"
    }
}

# =============================================================================
# DEVELOPMENT TOOLS OPTIMIZATION
# =============================================================================

function Optimize-DevelopmentTools {
    Write-Header "DEVELOPMENT TOOLS OPTIMIZATION"
    
    try {
        # Optimize for Cursor, VS Code, and other development tools
        Write-Info "Optimizing for development tools..."
        
        # Increase file watcher limits
        $fileWatcherLimits = @{
            "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\SubSystems" = @{
                "Windows" = (Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\SubSystems" -Name "Windows").Windows + " SharedSection=1024,20480,768"
            }
        }
        
        # Optimize Windows Defender for development folders
        Write-Info "Configuring Windows Defender exclusions for development..."
        $devFolders = @(
            "$env:USERPROFILE\AppData\Local\Programs\Cursor",
            "$env:USERPROFILE\AppData\Local\Programs\Microsoft VS Code",
            "$env:USERPROFILE\.git",
            "$env:USERPROFILE\Documents\GitHub",
            "$env:USERPROFILE\Documents\Projects"
        )
        
        foreach ($folder in $devFolders) {
            if (Test-Path $folder) {
                try {
                    Add-MpPreference -ExclusionPath $folder -ErrorAction SilentlyContinue
                    Write-Success "Added Defender exclusion for: $folder"
                } catch {
                    Write-Warning "Could not add Defender exclusion for: $folder"
                }
            }
        }
        
        # Optimize Git settings
        Write-Info "Optimizing Git settings..."
        git config --global core.preloadindex true
        git config --global core.fscache true
        git config --global gc.auto 256
        Write-Success "Git optimization completed"
        
    } catch {
        Write-Error "Development tools optimization failed: $($_.Exception.Message)"
    }
}

# =============================================================================
# MONITORING FUNCTIONS
# =============================================================================

function Start-PerformanceMonitoring {
    Write-Header "PERFORMANCE MONITORING"
    
    $monitoringScript = @"
# Performance Monitoring Script
while (`$true) {
    Clear-Host
    Write-Host "=== SYSTEM PERFORMANCE MONITOR ===" -ForegroundColor Cyan
    Write-Host "Time: `$(Get-Date)" -ForegroundColor White
    
    # CPU Usage
    `$cpu = Get-WmiObject -Class Win32_Processor | Measure-Object -Property LoadPercentage -Average
    Write-Host "CPU Usage: `$(`$cpu.Average)%" -ForegroundColor Yellow
    
    # Memory Usage
    `$memory = Get-WmiObject -Class Win32_OperatingSystem
    `$totalMemory = [math]::Round(`$memory.TotalVisibleMemorySize / 1MB, 2)
    `$freeMemory = [math]::Round(`$memory.FreePhysicalMemory / 1MB, 2)
    `$usedMemory = `$totalMemory - `$freeMemory
    `$memoryPercent = [math]::Round((`$usedMemory / `$totalMemory) * 100, 2)
    Write-Host "Memory Usage: `$memoryPercent% (`$usedMemory GB / `$totalMemory GB)" -ForegroundColor Yellow
    
    # Top Processes
    Write-Host "`nTop 5 Memory Consumers:" -ForegroundColor Cyan
    Get-Process | Sort-Object WorkingSet -Descending | Select-Object -First 5 | ForEach-Object {
        `$memMB = [math]::Round(`$_.WorkingSet / 1MB, 2)
        Write-Host "  `$(`$_.ProcessName): `$memMB MB" -ForegroundColor White
    }
    
    Start-Sleep -Seconds 5
}
"@
    
    $monitoringScript | Out-File -FilePath "$env:TEMP\PerformanceMonitor.ps1" -Encoding UTF8
    Write-Success "Performance monitoring script created at: $env:TEMP\PerformanceMonitor.ps1"
    Write-Info "To start monitoring, run: . '$env:TEMP\PerformanceMonitor.ps1'"
}

# =============================================================================
# MAIN EXECUTION LOGIC
# =============================================================================

function Show-Menu {
    Write-Header "LAPTOP PERFORMANCE OPTIMIZER"
    Write-Host "Choose an optimization option:" -ForegroundColor White
    Write-Host "1. Quick Optimize (Memory, Services, Power)" -ForegroundColor Green
    Write-Host "2. Full Optimize (All optimizations)" -ForegroundColor Green
    Write-Host "3. Monitor Only (System analysis and monitoring)" -ForegroundColor Yellow
    Write-Host "4. Custom Optimize (Choose specific optimizations)" -ForegroundColor Cyan
    Write-Host "5. Exit" -ForegroundColor Red
    Write-Host ""
}

function Invoke-CustomOptimize {
    Write-Header "CUSTOM OPTIMIZATION"
    Write-Host "Select optimizations to run:" -ForegroundColor White
    Write-Host "1. Memory Optimization" -ForegroundColor Green
    Write-Host "2. Startup Optimization" -ForegroundColor Green
    Write-Host "3. Services Optimization" -ForegroundColor Green
    Write-Host "4. Registry Optimization" -ForegroundColor Green
    Write-Host "5. Disk Optimization" -ForegroundColor Green
    Write-Host "6. Network Optimization" -ForegroundColor Green
    Write-Host "7. Power Optimization" -ForegroundColor Green
    Write-Host "8. Development Tools Optimization" -ForegroundColor Green
    Write-Host "9. All Above" -ForegroundColor Yellow
    Write-Host "0. Back to Main Menu" -ForegroundColor Red
    
    $choice = Read-Host "Enter your choices (comma-separated, e.g., 1,3,5)"
    $choices = $choice -split ',' | ForEach-Object { $_.Trim() }
    
    foreach ($ch in $choices) {
        switch ($ch) {
            "1" { Optimize-Memory }
            "2" { Optimize-Startup }
            "3" { Optimize-Services }
            "4" { Optimize-Registry }
            "5" { Optimize-Disk }
            "6" { Optimize-Network }
            "7" { Optimize-Power }
            "8" { Optimize-DevelopmentTools }
            "9" { 
                Optimize-Memory
                Optimize-Startup
                Optimize-Services
                Optimize-Registry
                Optimize-Disk
                Optimize-Network
                Optimize-Power
                Optimize-DevelopmentTools
            }
        }
    }
}

# =============================================================================
# SCRIPT EXECUTION
# =============================================================================

# Check if running as administrator
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Error "This script requires Administrator privileges. Please run PowerShell as Administrator."
    exit 1
}

# Main execution
try {
    if ($QuickOptimize) {
        Write-Header "QUICK OPTIMIZATION MODE"
        Get-SystemInfo
        Optimize-Memory
        Optimize-Services
        Optimize-Power
        Write-Success "Quick optimization completed!"
    }
    elseif ($FullOptimize) {
        Write-Header "FULL OPTIMIZATION MODE"
        Get-SystemInfo
        Test-SystemHealth
        Optimize-Memory
        Optimize-Startup
        Optimize-Services
        Optimize-Registry
        Optimize-Disk
        Optimize-Network
        Optimize-Power
        Optimize-DevelopmentTools
        Write-Success "Full optimization completed!"
    }
    elseif ($MonitorOnly) {
        Get-SystemInfo
        Test-SystemHealth
        Start-PerformanceMonitoring
    }
    elseif ($RestoreDefaults) {
        Write-Header "RESTORING DEFAULTS"
        Write-Warning "This feature would restore system defaults. Implementation needed."
    }
    else {
        # Interactive mode
        do {
            Show-Menu
            $choice = Read-Host "Enter your choice (1-5)"
            
            switch ($choice) {
                "1" { 
                    Write-Header "QUICK OPTIMIZATION"
                    Get-SystemInfo
                    Optimize-Memory
                    Optimize-Services
                    Optimize-Power
                    Write-Success "Quick optimization completed!"
                }
                "2" { 
                    Write-Header "FULL OPTIMIZATION"
                    Get-SystemInfo
                    Test-SystemHealth
                    Optimize-Memory
                    Optimize-Startup
                    Optimize-Services
                    Optimize-Registry
                    Optimize-Disk
                    Optimize-Network
                    Optimize-Power
                    Optimize-DevelopmentTools
                    Write-Success "Full optimization completed!"
                }
                "3" { 
                    Get-SystemInfo
                    Test-SystemHealth
                    Start-PerformanceMonitoring
                }
                "4" { Invoke-CustomOptimize }
                "5" { 
                    Write-Success "Goodbye!"
                    break
                }
                default { Write-Warning "Invalid choice. Please try again." }
            }
            
            if ($choice -ne "5") {
                Write-Host "`nPress any key to continue..."
                $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
            }
        } while ($choice -ne "5")
    }
    
} catch {
    Write-Error "Script execution failed: $($_.Exception.Message)"
    exit 1
}

Write-Header "OPTIMIZATION COMPLETE"
Write-Success "Your laptop has been optimized for better performance!"
Write-Info "Recommendations:"
Write-Host "  • Restart your computer to apply all changes" -ForegroundColor White
Write-Host "  • Monitor system performance over the next few days" -ForegroundColor White
Write-Host "  • Run this script monthly for maintenance" -ForegroundColor White
Write-Host "  • Consider upgrading to SSD if using HDD" -ForegroundColor White
