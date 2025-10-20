$ErrorActionPreference = 'Stop'
Set-Location -LiteralPath (Split-Path $PSScriptRoot -Parent)
Set-Location -LiteralPath './backend'
./release-auto-version.ps1

