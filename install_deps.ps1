Invoke-WebRequest -Uri "https://autohotkey.com/download/ahk.zip" -OutFile "ahk.zip"
Invoke-WebRequest -Uri "https://web.archive.org/web/20150511220826if_/http://www.matcode.com/mpress.219.zip" -OutFile "mpress.zip"

Expand-Archive -LiteralPath .\ahk.zip -DestinationPath .\ahk
Expand-Archive -LiteralPath .\mpress.zip -DestinationPath .\ahk\Compiler\

Remove-Item .\ahk.zip, .\mpress.zip
