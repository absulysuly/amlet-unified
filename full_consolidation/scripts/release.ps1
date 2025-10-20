$ErrorActionPreference = 'Stop'
Set-Location -LiteralPath (Split-Path $PSScriptRoot -Parent)

Write-Host '🔧 Ensuring backend is ready...'
Set-Location -LiteralPath './backend'
npm install
npm run build

Write-Host '🏷️  Tagging and generating changelog...'
./release-auto-version.ps1

Write-Host '✅ Release script completed.'

