﻿$ErrorActionPreference = 'Stop';

$packageName = 'twitch'
$installerType = 'exe'
$url = 'https://updates.twitchapp.net/windows/installer/TwitchSetup.exe'
$silentArgs = '/silent'
$validExitCodes = @(0, 1638)

if (-not $env:ChocolateyForce) {
  try {
    $TwitchExeHandler = Get-ItemPropertyValue -Path "Microsoft.PowerShell.Core\Registry::HKEY_CLASSES_ROOT\twitch\shell\open\command"-Name "(default)"
    $TwitchExePath = [System.Management.Automation.PSParser]::Tokenize($TwitchExeHandler, [ref] $null) | Select-Object -First 1 -ExpandProperty "Content"
    $InstalledVersion = (Get-Item -Path $TwitchExePath).VersionInfo.ProductVersion

    if ([Version]::Parse($InstalledVersion) -ge [Version]::Parse($env:ChocolateyPackageVersion))
    {
      Write-Host "Skipping installation because version $InstalledVersion is already installed."
      return
    }
  } catch {
    # Installed version couldn't be checked, attempt installation
  }
}

Install-ChocolateyPackage "$packageName" "$installerType" "$silentArgs" "$url"  -validExitCodes $validExitCodes -Checksum FBEAFC0C3A006C44CF67105D2EE458F426A00F25C52D5BAE7159B04967CE90DF -ChecksumType sha256
