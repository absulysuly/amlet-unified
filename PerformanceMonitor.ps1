# =============================================================================
# REAL-TIME PERFORMANCE MONITOR
# =============================================================================
# Companion script for LaptopOptimizer.ps1
# Provides real-time system performance monitoring
# =============================================================================

param(
    [int]$RefreshInterval = 5,
    [switch]$LogToFile,
    [string]$LogPath = "$env:TEMP\PerformanceLog.csv"
)

# Color functions
function Write-ColorOutput {
    param([string]$Message, [string]$Color = "White")
    Write-Host $Message -ForegroundColor $Color
}

function Get-CPUUsage {
    $cpu = Get-WmiObject -Class Win32_Processor | Measure-Object -Property LoadPercentage -Average
    return [math]::Round($cpu.Average, 2)
}

function Get-MemoryUsage {
    $memory = Get-WmiObject -Class Win32_OperatingSystem
    $totalMemory = [math]::Round($memory.TotalVisibleMemorySize / 1MB, 2)
    $freeMemory = [math]::Round($memory.FreePhysicalMemory / 1MB, 2)
    $usedMemory = $totalMemory - $freeMemory
    $memoryPercent = [math]::Round(($usedMemory / $totalMemory) * 100, 2)
    
    return @{
        Total = $totalMemory
        Used = $usedMemory
        Free = $freeMemory
        Percent = $memoryPercent
    }
}

function Get-DiskUsage {
    $drives = Get-WmiObject -Class Win32_LogicalDisk | Where-Object {$_.DriveType -eq 3}
    $diskInfo = @()
    
    foreach ($drive in $drives) {
        $totalSpace = [math]::Round($drive.Size / 1GB, 2)
        $freeSpace = [math]::Round($drive.FreeSpace / 1GB, 2)
        $usedSpace = $totalSpace - $freeSpace
        $percentUsed = [math]::Round(($usedSpace / $totalSpace) * 100, 2)
        
        $diskInfo += @{
            Drive = $drive.DeviceID
            Total = $totalSpace
            Used = $usedSpace
            Free = $freeSpace
            Percent = $percentUsed
        }
    }
    
    return $diskInfo
}

function Get-TopProcesses {
    return Get-Process | Sort-Object WorkingSet -Descending | Select-Object -First 10 | ForEach-Object {
        @{
            Name = $_.ProcessName
            MemoryMB = [math]::Round($_.WorkingSet / 1MB, 2)
            CPU = $_.CPU
            PID = $_.Id
        }
    }
}

function Show-PerformanceDashboard {
    Clear-Host
    
    # Header
    Write-ColorOutput "=" * 80 "Cyan"
    Write-ColorOutput "                    REAL-TIME PERFORMANCE MONITOR" "Yellow"
    Write-ColorOutput "=" * 80 "Cyan"
    Write-ColorOutput "Time: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" "White"
    Write-ColorOutput "Refresh Interval: $RefreshInterval seconds" "White"
    Write-ColorOutput ""
    
    # CPU Usage
    $cpuUsage = Get-CPUUsage
    $cpuColor = if ($cpuUsage -gt 80) { "Red" } elseif ($cpuUsage -gt 60) { "Yellow" } else { "Green" }
    Write-ColorOutput "CPU Usage: $cpuUsage%" $cpuColor
    
    # Memory Usage
    $memoryInfo = Get-MemoryUsage
    $memoryColor = if ($memoryInfo.Percent -gt 85) { "Red" } elseif ($memoryInfo.Percent -gt 70) { "Yellow" } else { "Green" }
    Write-ColorOutput "Memory Usage: $($memoryInfo.Percent)% ($($memoryInfo.Used) GB / $($memoryInfo.Total) GB)" $memoryColor
    
    # Disk Usage
    Write-ColorOutput "`nDisk Usage:" "Cyan"
    $diskInfo = Get-DiskUsage
    foreach ($disk in $diskInfo) {
        $diskColor = if ($disk.Percent -gt 90) { "Red" } elseif ($disk.Percent -gt 80) { "Yellow" } else { "Green" }
        Write-ColorOutput "  $($disk.Drive) $($disk.Percent)% ($($disk.Used) GB / $($disk.Total) GB)" $diskColor
    }
    
    # Top Processes
    Write-ColorOutput "`nTop 10 Memory Consumers:" "Cyan"
    $topProcesses = Get-TopProcesses
    foreach ($process in $topProcesses) {
        $processColor = if ($process.MemoryMB -gt 1000) { "Red" } elseif ($process.MemoryMB -gt 500) { "Yellow" } else { "White" }
        Write-ColorOutput "  $($process.Name): $($process.MemoryMB) MB (PID: $($process.PID))" $processColor
    }
    
    # Network Activity
    Write-ColorOutput "`nNetwork Interfaces:" "Cyan"
    $networkAdapters = Get-NetAdapter | Where-Object {$_.Status -eq "Up"}
    foreach ($adapter in $networkAdapters) {
        $stats = Get-NetAdapterStatistics -Name $adapter.Name
        $bytesReceived = [math]::Round($stats.BytesReceived / 1MB, 2)
        $bytesSent = [math]::Round($stats.BytesSent / 1MB, 2)
        Write-ColorOutput "  $($adapter.Name): RX $bytesReceived MB, TX $bytesSent MB" "White"
    }
    
    # Performance Warnings
    Write-ColorOutput "`nPerformance Warnings:" "Cyan"
    $warnings = @()
    
    if ($cpuUsage -gt 80) { $warnings += "High CPU usage detected" }
    if ($memoryInfo.Percent -gt 85) { $warnings += "High memory usage detected" }
    foreach ($disk in $diskInfo) {
        if ($disk.Percent -gt 90) { $warnings += "Low disk space on $($disk.Drive)" }
    }
    
    if ($warnings.Count -eq 0) {
        Write-ColorOutput "  No warnings - System performing well" "Green"
    } else {
        foreach ($warning in $warnings) {
            Write-ColorOutput "  ⚠ $warning" "Yellow"
        }
    }
    
    Write-ColorOutput "`n" + "=" * 80 "Cyan"
    Write-ColorOutput "Press Ctrl+C to stop monitoring" "Red"
}

function Log-PerformanceData {
    param([string]$LogPath)
    
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $cpuUsage = Get-CPUUsage
    $memoryInfo = Get-MemoryUsage
    $diskInfo = Get-DiskUsage
    
    $logEntry = "$timestamp,$cpuUsage,$($memoryInfo.Percent),$($memoryInfo.Used),$($memoryInfo.Total)"
    
    foreach ($disk in $diskInfo) {
        $logEntry += ",$($disk.Drive),$($disk.Percent),$($disk.Used),$($disk.Total)"
    }
    
    # Add CSV header if file doesn't exist
    if (-not (Test-Path $LogPath)) {
        $header = "Timestamp,CPU%,Memory%,MemoryUsedGB,MemoryTotalGB"
        foreach ($disk in $diskInfo) {
            $header += ",$($disk.Drive)%,$($disk.Drive)UsedGB,$($disk.Drive)TotalGB"
        }
        $header | Out-File -FilePath $LogPath -Encoding UTF8
    }
    
    $logEntry | Out-File -FilePath $LogPath -Append -Encoding UTF8
}

# Main monitoring loop
try {
    Write-ColorOutput "Starting Performance Monitor..." "Green"
    Write-ColorOutput "Logging to file: $LogToFile" "White"
    if ($LogToFile) {
        Write-ColorOutput "Log file: $LogPath" "White"
    }
    Write-ColorOutput "Press Ctrl+C to stop" "Yellow"
    Start-Sleep -Seconds 2
    
    while ($true) {
        Show-PerformanceDashboard
        
        if ($LogToFile) {
            Log-PerformanceData -LogPath $LogPath
        }
        
        Start-Sleep -Seconds $RefreshInterval
    }
} catch {
    Write-ColorOutput "`nMonitoring stopped." "Yellow"
    if ($LogToFile) {
        Write-ColorOutput "Performance log saved to: $LogPath" "Green"
    }
}
