$OUTPUT = "build\unrailed-save-scummer.exe"
$TAG = "$(git describe --tags)".Split("v")[1..-0] -join "v"

# Delete old build
if (Test-Path -Path "build\") {
  Remove-Item -Recurse "build\"
}
New-Item -Path "build\" -ItemType directory > $null

$global:FileChanged = $false
function Wait-FileChange {
  param(
    [string]$File,
    [string]$Action
  )
  $FilePath = Split-Path $File -Parent
  $FileName = Split-Path $File -Leaf
  $ScriptBlock = [scriptblock]::Create($Action)

  $Watcher = New-Object IO.FileSystemWatcher $FilePath, $FileName -Property @{ 
    IncludeSubdirectories = $false
    EnableRaisingEvents = $true
  }
  $onChange = Register-ObjectEvent $Watcher Created -Action {$global:FileChanged = $true}

  while ($global:FileChanged -eq $false){
    Start-Sleep -Milliseconds 100
  }

  & $ScriptBlock 
  Unregister-Event -SubscriptionId $onChange.Id
}

.\lib\ahk\Compiler\Ahk2Exe.exe `
  /in ".\src\unrailed-save-scummer.ahk" `
  /out ".\$OUTPUT" `
  /icon ".\assets\icon.ico" `
  /bin "$(Get-Location)\lib\ahk\Compiler\AutoHotkeySC.bin" `
  /compress 1
if ($LASTEXITCODE -ne 0) { throw "Exit code is $LASTEXITCODE" }

# Watch for the .exe file to be created because ahk2exe returns early...
$Action = @"
Write-Output "$OUTPUT built"
Start-Sleep -Seconds 3
.\lib\rcedit.exe .\$OUTPUT --set-file-version "$TAG"
"@
Wait-FileChange "$(Get-Location)\$OUTPUT" $Action
