$rootPath = "D:\repos"
$defaultConfig = @"
{
   "tabs": [
      {
         "title": "nvim",
         "cmd": "nvim" 
      },
      {
         "title": "cmd",
      }
   ]
}
"@

function Get-ProjectDirectories {
   param ([string]$RootPath)
   Get-ChildItem -Path $RootPath -Directory | Select-Object -ExpandProperty FullName
}

function Load-ConfigAndExecute {
   param ([string]$ProjectPath, [string]$ConfigPath)
   Set-Location $ProjectPath

   if (Test-Path $ConfigPath) {
      $config = Get-Content $ConfigPath | ConvertFrom-Json
      $idx = 0
      $initTabId = 0

      $tabCommands = @{}

      foreach ($tab in $config.tabs) {
         $result1 = wezterm cli list --format json | Out-String
         $data1 = $result1 | ConvertFrom-Json
         $initTabId = $data1[0].tab_id

         if ($idx -ne 0) {
            wezterm cli spawn --cwd $ProjectPath
            Start-Sleep -Milliseconds 100

            $result2 = wezterm cli list --format json | Out-String
            $data2 = $result2 | ConvertFrom-Json
            $tabIds1 = $data1 | ForEach-Object { $_.tab_id }
            $newTabId = $data2 | Where-Object { $_.tab_id -notin $tabIds1 } | Select-Object -ExpandProperty tab_id
            wezterm cli set-tab-title --tab-id $newTabId $tab.title

            if ($tab.cmd) {
               $tabCommands[$newTabId] = $tab.cmd
            }
            else {
               $tabCommands[$newTabId] = "clear"
            }
         }
         else {
            wezterm cli set-tab-title --tab-id $initTabId $tab.title
            if ($tab.cmd) {
               $tabCommands[$initTabId] = $tab.cmd
            }
            else {
               $tabCommands[$initTabId] = "clear"
            }
         }

         $idx++
      }

      foreach ($tabId in $tabCommands.Keys) {
         wezterm cli activate-tab --tab-id $tabId
         Invoke-Expression $tabCommands[$tabId]
      }

      wezterm cli activate-tab --tab-id $initTabId
   }
}

function CreateNewProject {
   param ([string]$RootPath, [string]$DefaultConfig)

   $projectName = Read-Host "Name"
   if ([string]::IsNullOrEmpty($projectName)) {
      return
   }

   $newProjectPath = Join-Path $RootPath $projectName
   if (Test-Path $newProjectPath) {
      return
   }
   else {
      New-Item -ItemType Directory -Path $newProjectPath | Out-Null
      $configPath = Join-Path $newProjectPath ".acproj"
      $DefaultConfig | Out-File -FilePath $configPath -Encoding utf8
   }

   Load-ConfigAndExecute -ProjectPath $newProjectPath -ConfigPath $configPath
}

$projects = Get-ProjectDirectories -RootPath $rootPath
Write-Host "[0] Create new.. "
for ($i = 0; $i -lt $projects.Count; $i++) {
   $projName = Split-Path $projects[$i] -Leaf
   Write-Host "[$($i+1)] $($projName)"
}
$selection = Read-Host "$"
if ($selection -eq "0") {
   CreateNewProject -RootPath $rootPath -DefaultConfig $defaultConfig
}
elseif ([int]::TryParse($selection, [ref]$null) -and $selection -ge 1 -and $selection -le $projects.Count) {
   $selectedProject = $projects[$selection - 1]
   $configPath = Join-Path $selectedProject ".acproj"
   Load-ConfigAndExecute -ProjectPath $selectedProject -ConfigPath $configPath
}
