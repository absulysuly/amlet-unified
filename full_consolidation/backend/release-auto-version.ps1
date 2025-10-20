$ErrorActionPreference = 'Stop'

function Get-LastTagSafe {
  try {
    $t = (git describe --tags --abbrev=0 2>$null)
    if (-not $t) { return 'v0.1.0' }
    return $t
  } catch { return 'v0.1.0' }
}

$commitMsg = (git log -1 --pretty=format:%s)
if (-not $commitMsg) { $commitMsg = 'chore: manual release' }

$lastTag = Get-LastTagSafe
$parts = $lastTag.TrimStart('v') -split '\.'
[int]$major = if ($parts.Length -gt 0) { $parts[0] } else { 0 }
[int]$minor = if ($parts.Length -gt 1) { $parts[1] } else { 1 }
[int]$patch = if ($parts.Length -gt 2) { $parts[2] } else { 0 }

if ($commitMsg -match 'BREAKING CHANGE') { $major++; $minor = 0; $patch = 0 }
elseif ($commitMsg -match '^(feat|feature)') { $minor++; $patch = 0 }
elseif ($commitMsg -match '^(fix|chore|refactor|docs)') { $patch++ } else { $patch++ }

$newTag = "v$major.$minor.$patch"
Write-Host "🚀 New Version: $newTag"

git add .
try { git commit -m "chore: release $newTag" } catch { Write-Host 'No changes to commit.' }
git push origin HEAD

git tag -a $newTag -m "Automated release for $commitMsg"
git push origin $newTag

$releaseDate = Get-Date -Format 'yyyy-MM-dd'
$log = @"
## 📦 $newTag — $releaseDate
- Commit: $commitMsg
- Frontend: https://copy-of-hamlet-social.vercel.app
- Backend: https://hamlet-backend.onrender.com
"@

# Append changelog in both backend and frontend folders for visibility
$paths = @(
  Join-Path $PSScriptRoot 'CHANGELOG.md'),
  (Join-Path (Split-Path $PSScriptRoot -Parent) 'frontend-aigoodstudeio' 'CHANGELOG.md')

foreach ($p in $paths) {
  if (-not (Test-Path $p)) { New-Item -ItemType File -Path $p -Force | Out-Null }
  Add-Content -Path $p -Value $log
}

git add .
try { git commit -m "docs: update changelog for $newTag" } catch { Write-Host 'No changelog changes to commit.' }
git push origin HEAD

# Optional: Create GitHub release (requires PAT)
if ($env:GITHUB_TOKEN) {
  $headers = @{ Authorization = "token $($env:GITHUB_TOKEN)" }
  $body = @{ tag_name = $newTag; name = "Hamlet Platform $newTag"; body = "Automated release from $commitMsg"; draft = $false } | ConvertTo-Json
  $repo = if ($env:GITHUB_REPOSITORY) { $env:GITHUB_REPOSITORY } else { Read-Host 'Enter repo (owner/name)' }
  Invoke-RestMethod -Uri "https://api.github.com/repos/$repo/releases" -Method POST -Headers $headers -Body $body -ContentType 'application/json'
  Write-Host "✅ Release $newTag created and published to GitHub!"
} else {
  Write-Host 'ℹ️ Skipping GitHub release (set GITHUB_TOKEN and GITHUB_REPOSITORY to enable)'
}

