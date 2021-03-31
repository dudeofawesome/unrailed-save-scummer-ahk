#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#MaxThreadsPerHotkey 2 ; Allows the hotkey to toggle the reader
#Persistent ; Keeps the script running in the background

EnvGet, LocalAppData, LOCALAPPDATA
save_game_dir := LocalAppData . "\Daedalic Entertainment GmbH\Unrailed\GameState\AllPlayers\SaveGames"
last_time_save_loaded := 0
last_event_time := 0

WatchDirectory(save_game_dir . "\|.sav", "onSaveDetected")

onSaveDetected(old_filepath, new_filepath) {
  global save_game_dir
  global last_time_save_loaded
  global last_event_time

  backups_dir := save_game_dir . "\backups"

  ; naïvely check that this isn't a duplicate event
  if (last_event_time + 2000 < A_TickCount) {
    if ((!old_filepath and !!new_filepath) or old_filepath = new_filepath) {
      ; new file is being created (what an awful interface)

      ; naïvely check that we didn't cause this event
      if (last_time_save_loaded + 2000 < A_TickCount) {
        SplitPath, new_filepath, basename, , extension, filename

        TrayTip, New Save Detected, %basename%

        ; create backups dir if it doesn't exist
        if (!FileExist(backups_dir)) {
          FileCreateDir, %backups_dir%
        }

        rotateSaves(backups_dir, filename, extension)
        FileCopy, %new_filepath%, %backups_dir%\%filename%-0.%extension%, 0
      }
    } else if (!!old_filepath and !new_filepath) {
      ; file is being deleted (what an awful interface)

      last_time_save_loaded := A_TickCount

      SplitPath, old_filepath, basename, , extension, filename

      ; wait a little bit just to make sure the game doesn't do anything funky
      Sleep, 1000

      if (FileExist(backups_dir . "\" . filename . "-0." . extension)) {
        FileCopy, %backups_dir%\%filename%-0.%extension%, %save_game_dir%\%filename%.%extension%, 0
      }
    }
  }

  last_event_time := A_TickCount
}

rotateSaves(dir, filename, extension) {
  max_saves := 5

  oldest_save := dir . "\" . filename . "-" . max_saves . "." . extension
  if (FileExist(oldest_save)) {
    FileDelete, %oldest_save%
  }
  
  Loop, %max_saves% {
    i := max_saves - A_Index
    from := dir . "\" . filename . "-" . i . "." . extension
    to := dir . "\" . filename . "-" . (i + 1) . "." . extension

    if (FileExist(from)) {
      FileMove, %from%, %to%, 0
    }
  }
}
