# Creates a new Laby Client addon from the addon template, ready for AI coding agents.
# Usage: irm https://dev.labymod.net/new-addon.ps1 | iex
#
# Installs what is missing (JDK 25, Node.js, Git) with winget after asking, downloads the addon template,
# renames it to your addon and sets up the MCP servers, skills and AGENTS.md for Claude Code, Codex and Gemini CLI.

# A script block, so the settings and helpers below don't stay behind in the shell that ran irm | iex
& {
$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'

$TemplateUrl = 'https://github.com/LabyMod/addon-template/archive/refs/heads/master.zip'
if ($env:LABY_ADDON_TEMPLATE) {
  $TemplateUrl = $env:LABY_ADDON_TEMPLATE
}

function Write-Step($text) {
  Write-Host ''
  Write-Host "==> $text" -ForegroundColor Cyan
}

function Read-Answer($question, $default) {
  $suffix = ''
  if ($default) {
    $suffix = " [$default]"
  }
  $answer = Read-Host "$question$suffix"
  if ([string]::IsNullOrWhiteSpace($answer)) {
    return $default
  }
  return $answer.Trim()
}

function Confirm-Step($question) {
  $answer = Read-Host "$question [Y/n]"
  return [string]::IsNullOrWhiteSpace($answer) -or $answer -match '^[yYjJ]'
}

function Update-SessionPath {
  $machine = [Environment]::GetEnvironmentVariable('Path', 'Machine')
  $user = [Environment]::GetEnvironmentVariable('Path', 'User')
  $env:Path = "$machine;$user"
}

# java -version prints to stderr; cmd.exe keeps PowerShell from turning that into an error
function Get-JavaMajor {
  if (-not (Get-Command java -ErrorAction SilentlyContinue)) {
    return 0
  }
  $output = & $env:ComSpec /c 'java -version 2>&1' | Out-String
  if ($output -match 'version "1\.(\d+)') {
    return [int]$Matches[1]
  }
  if ($output -match 'version "(\d+)') {
    return [int]$Matches[1]
  }
  return 0
}

function Get-NodeMajor {
  if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
    return 0
  }
  $output = & $env:ComSpec /c 'node --version 2>&1' | Out-String
  if ($output -match 'v(\d+)') {
    return [int]$Matches[1]
  }
  return 0
}

function Install-Package($id, $label) {
  if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    throw "winget is not available. Install $label yourself, then run this script again."
  }
  Write-Host "Installing $label with winget..."
  winget install --id $id --exact --silent --accept-source-agreements --accept-package-agreements
  if ($LASTEXITCODE -ne 0) {
    throw "winget could not install $label (exit code $LASTEXITCODE)."
  }
  Update-SessionPath
}

# The Temurin installer adds java to PATH, but an older Java earlier on PATH can still win
function Use-InstalledJdk {
  $jdk = Get-ChildItem 'C:\Program Files\Eclipse Adoptium' -Directory -Filter 'jdk-25*' -ErrorAction SilentlyContinue |
    Sort-Object Name -Descending | Select-Object -First 1
  if ($jdk) {
    $env:JAVA_HOME = $jdk.FullName
    $env:Path = "$($jdk.FullName)\bin;$env:Path"
  }
}

function Test-Name($value, $pattern) {
  return $value -cmatch $pattern
}

Write-Host 'Laby Client addon setup' -ForegroundColor Green
Write-Host 'This creates a new addon project from the official template and prepares it for AI coding agents.'

Write-Step 'Checking prerequisites'
if ((Get-JavaMajor) -lt 25) {
  Write-Host 'JDK 25 or newer was not found. Addons need it because Minecraft 26.1 and later run on Java 25.'
  if (-not (Confirm-Step 'Install Eclipse Temurin JDK 25 now?')) {
    throw 'JDK 25 is required. Install it from https://adoptium.net and run this script again.'
  }
  Install-Package 'EclipseAdoptium.Temurin.25.JDK' 'Eclipse Temurin JDK 25'
  if ((Get-JavaMajor) -lt 25) {
    Use-InstalledJdk
  }
  if ((Get-JavaMajor) -lt 25) {
    throw 'JDK 25 was installed, but this window still finds an older Java. Open a new terminal and run the script again.'
  }
}
Write-Host "Java $(Get-JavaMajor): ok"

if ((Get-NodeMajor) -lt 18) {
  Write-Host 'Node.js 18 or newer runs the laby-client tool that lets AI agents control the game. It was not found.'
  if (Confirm-Step 'Install Node.js LTS now?') {
    Install-Package 'OpenJS.NodeJS.LTS' 'Node.js LTS'
  } else {
    Write-Host 'Skipped. Everything else works; the agent just cannot drive the running client.' -ForegroundColor Yellow
  }
}
if ((Get-NodeMajor) -ge 18) {
  Write-Host "Node.js $(Get-NodeMajor): ok"
}

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
  Write-Host 'Git is recommended: AI agents use it to review and undo their changes. It was not found.'
  if (Confirm-Step 'Install Git now?') {
    Install-Package 'Git.Git' 'Git'
  }
}

Write-Step 'About your addon'
$name = ''
while ([string]::IsNullOrWhiteSpace($name)) {
  $name = Read-Answer 'Addon name, shown in the addon store (e.g. Chat Tools)' ''
}

$defaultNamespace = ($name.ToLowerInvariant() -replace '[^a-z0-9]', '')
$namespace = Read-Answer 'Namespace, a unique id (lowercase letters, digits, _ . -)' $defaultNamespace
while (-not (Test-Name $namespace '^[a-z0-9_.-]+$') -or $namespace -eq 'example') {
  $namespace = Read-Answer 'Use only lowercase letters, digits, _ . - (and not "example")' $defaultNamespace
}

$author = Read-Answer 'Author' $env:USERNAME
$authorPart = ($author.ToLowerInvariant() -replace '[^a-z0-9]', '')
if (-not $authorPart -or $authorPart -match '^[0-9]') {
  $authorPart = 'addon'
}
$namespacePart = ($namespace -replace '[^a-z0-9_]', '')
if ($namespacePart -match '^[0-9]') {
  $namespacePart = "_$namespacePart"
}
$defaultPackage = "com.$authorPart.$namespacePart"
$package = Read-Answer 'Main Java package' $defaultPackage
while (-not (Test-Name $package '^[a-z_][a-z0-9_]*(\.[a-z_][a-z0-9_]*)*$') -or $package -match '^org\.example\b') {
  $package = Read-Answer 'Use lowercase words separated by dots, e.g. com.yourname.chattools' $defaultPackage
}

$directory = Join-Path (Get-Location) $namespace
$directory = Read-Answer 'Create the project in' $directory
if (Test-Path $directory) {
  throw "$directory already exists. Choose another folder or remove it first."
}

Write-Step 'Downloading the addon template'
$temp = Join-Path ([IO.Path]::GetTempPath()) ("laby-addon-" + [Guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Path $temp | Out-Null
try {
  $zip = Join-Path $temp 'template.zip'
  if (Test-Path $TemplateUrl) {
    Copy-Item $TemplateUrl $zip
  } else {
    Invoke-WebRequest -UseBasicParsing -Uri $TemplateUrl -OutFile $zip
  }
  Expand-Archive -Path $zip -DestinationPath (Join-Path $temp 'unpacked')
  $templateRoot = Get-ChildItem (Join-Path $temp 'unpacked') -Directory | Select-Object -First 1
  New-Item -ItemType Directory -Path (Split-Path $directory -Parent) -Force | Out-Null
  Move-Item $templateRoot.FullName $directory
} finally {
  Remove-Item $temp -Recurse -Force -ErrorAction SilentlyContinue
}

Set-Location $directory
Write-Step 'Renaming the template (the first run downloads Minecraft and LabyMod, this takes a few minutes)'
& .\gradlew.bat initAddon --name "$name" --namespace "$namespace" --package "$package" --author "$author"
if ($LASTEXITCODE -ne 0) {
  throw 'initAddon failed, see the output above.'
}

Write-Step 'Setting up the AI tools'
& .\gradlew.bat setupMcpServer
if ($LASTEXITCODE -ne 0) {
  throw 'setupMcpServer failed, see the output above.'
}

if (Get-Command git -ErrorAction SilentlyContinue) {
  git init --quiet
  git add --all
  if ((git config user.name) -and (git config user.email)) {
    git commit --quiet -m "Create $name from the Laby addon template"
  }
}

Write-Step "Done: $directory"
$agents = @()
foreach ($agent in 'claude', 'codex', 'gemini') {
  if (Get-Command $agent -ErrorAction SilentlyContinue) {
    $agents += $agent
  }
}
$newest = '<version>'
$versions = Select-String -Path 'gradle.properties' -Pattern '^net\.labymod\.minecraft-versions=(.+)$' | Select-Object -First 1
if ($versions) {
  $newest = $versions.Matches[0].Groups[1].Value.Split(';')[-1].Trim()
}
Write-Host 'Start your AI agent in the project folder and describe the addon you want to build:'
Write-Host "  cd `"$directory`""
if ($agents.Count -gt 0) {
  Write-Host "  $($agents[0])"
} else {
  Write-Host '  then run Claude Code (claude), Codex (codex) or Gemini CLI (gemini)'
}
Write-Host 'AGENTS.md tells the agent how this project works.'
Write-Host ''
Write-Host "Start the game with: .\gradlew.bat :game-runner:client_v$newest"
Write-Host 'To debug it, open the folder in IntelliJ IDEA.'
}
