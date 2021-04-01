ahk2exe := "C:\Program Files\AutoHotkey\Compiler\Ahk2Exe.exe"
bin := "C:\Program Files\AutoHotkey\Compiler\AutoHotkeySC.bin"

RunWait "%ahk2exe%" /in "%A_WorkingDir%\unrailed-save-scummer.ahk" /out "%A_WorkingDir%\unrailed-save-scummer.exe" /icon "%A_WorkingDir%\assets\icon.ico" /bin "%bin%" /compress 1
