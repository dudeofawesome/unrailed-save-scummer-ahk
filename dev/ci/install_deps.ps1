# Delete old dependencies
if (Test-Path -Path "lib\") {
  Remove-Item -Recurse "lib\"
}
New-Item -Path "lib\" -ItemType directory > $null


Invoke-WebRequest -Uri "https://autohotkey.com/download/ahk.zip" -OutFile "ahk.zip"
Invoke-WebRequest -Uri "https://web.archive.org/web/20150511220826if_/http://www.matcode.com/mpress.219.zip" -OutFile "mpress.zip"
Invoke-WebRequest -Uri "https://github.com/electron/rcedit/releases/download/v1.1.1/rcedit-x64.exe" -OutFile "lib\rcedit.exe"

Expand-Archive -LiteralPath .\ahk.zip -DestinationPath .\lib\ahk
Expand-Archive -LiteralPath .\mpress.zip -DestinationPath .\lib\ahk\Compiler\

Remove-Item .\ahk.zip, .\mpress.zip
