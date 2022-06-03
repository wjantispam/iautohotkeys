;------------------------------------------------------------------------------------------------------------
;   Symbol	Description
;   #	Win (Windows logo key)
;   !	Alt
;   ^	Ctrl
;   +	Shift
;   &	An ampersand may be used between any two keys or mouse buttons to combine them into a custom hotkey.
SetKeyDelay,0

; Expression (:=) syntax (recommended) and this is how to handle long lines. https://www.autohotkey.com/docs/Scripts.htm#continuation
Find_Biggest_Database := "
(
    SELECT count(*) TABLES,table_schema,concat(round(sum(table_rows)/1000000,2),'M') ``rows``,
    concat(round(sum(data_length)/(1024*1024*1024),2),'G') DATA,
    concat(round(sum(index_length)/(1024*1024*1024),2),'G') idx,
    concat(round(sum(data_length{+}index_length)/(1024*1024*1024),2),'G') total_size,
    round(sum(index_length)/sum(data_length),2) idxfrac 
    FROM information_schema.TABLES GROUP BY table_schema 
    ORDER BY sum(data_length{+}index_length) DESC LIMIT 10;
)"

Find_Table_Count_Data_Index_Size := "
(
    SELECT count(*) TABLES, concat(round(sum(table_rows)/1000000,2),'M') ``rows``, 
    concat(round(sum(data_length)/(1024*1024*1024),2),'G') DATA, 
    concat(round(sum(index_length)/(1024*1024*1024),2),'G') idx, 
    concat(round(sum(data_length{+}index_length)/(1024*1024*1024),2),'G') total_size, 
    round(sum(index_length)/sum(data_length),2) idxfrac 
    FROM information_schema.TABLES;
)"

Find_Table_Count_Data_Index_Size_With_Filters := "
(
    SELECT count(*) TABLES, concat(round(sum(table_rows)/1000000,2),'M') ``rows``, 
    concat(round(sum(data_length)/(1024*1024*1024),2),'G') DATA, 
    concat(round(sum(index_length)/(1024*1024*1024),2),'G') idx, 
    concat(round(sum(data_length{+}index_length)/(1024*1024*1024),2),'G') total_size, 
    round(sum(index_length)/sum(data_length),2) idxfrac 
    FROM information_schema.TABLES 
    WHERE table_name LIKE = '_USERINPUT_';
)"

Engine_Sizes := "
(
    SELECT engine, count(*) TABLES,concat(round(sum(table_rows)/1000000,2),'M') ``rows``,
    concat(round(sum(data_length)/(1024*1024*1024),2),'G') DATA,
    concat(round(sum(index_length)/(1024*1024*1024),2),'G') idx,
    concat(round(sum(data_length{+}index_length)/(1024*1024*1024),2),'G') total_size,
    round(sum(index_length)/sum(data_length),2) idxfrac 
    FROM information_schema.TABLES GROUP BY engine 
    ORDER BY sum(data_length{+}index_length) DESC LIMIT 10;
)"

Table_Sizes := "
(
    SELECT TABLE_NAME, CONCAT(ROUND((DATA_LENGTH{+}INDEX_LENGTH)/(1024*1024),2),'M') AS TABLE_SIZE 
    FROM information_schema.TABLES 
    WHERE table_schema='_USERINPUT_';
)"

; The second line is appended to the first because it begins with a comma. See https://www.autohotkey.com/docs/Scripts.htm
Email := {"1-Thanks"       : "test1"
        , "2-No thanks"    : "test2"}

dbmenuItems := []
dbmenuItems["Table data index"] := Find_Table_Count_Data_Index_Size
dbmenuItems["Table data index FOR TABLE_NAME"] := Find_Table_Count_Data_Index_Size_With_Filters 
dbmenuItems["Biggest Database"] := Find_Biggest_Database
dbmenuItems["Table sizes FOR TABLE_SCHEMA"] := Table_Sizes
dbmenuItems["Engine sizes"] := Engine_Sizes

;; Syntax: 
;; Menu, MenuName, Add [,MenuItemName, LabelOrSubmenu, Options]
For menuItem, string in Email
    Menu, MyMenu, Add, %menuItem%, MenuHandler2

For menuItem, _ in dbmenuItems
    Menu, dbmenuItems, Add, %menuItem%, MenuHandler
Menu, MyMenu, Add, Click for DB Stats, :dbmenuItems

return ;tells the script to go idle and wait for user input

MenuHandler:
; You will somehow need %% around A_ThisMenu to retrive the varialble but don't need it on A_ThisMenuItem
if Instr(%A_ThisMenu%[A_ThisMenuItem], "_USERINPUT_") and !ErrorLevel {
        if (getDB(userInput)) {
            command := % %A_ThisMenu%[A_ThisMenuItem] ;get the command string from the dbmenuItems array
            sendinput % RegExReplace(command,"_USERINPUT_",userInput)   ;send the command but also try and replace _USERINPUT_ with actual user input
        }
    }
Else
    SendInput % %A_ThisMenu%[A_ThisMenuItem]  
Return

MenuHandler2:
    SendInput % %A_ThisMenu%[A_ThisMenuItem]
Return

;byref UserInput means it's treated as input and output variable, so it gets updated in this function and returned as well
getDB(byref UserInput) {
    InputBox, UserInput, Database, Enter database key
    if (ErrorLevel) {
        MsgBox, CANCEL was pressed.
		return 0
	}
    return 1
}
;------------------------------------------------------------------------------------------------------------
; Alt+r to Save this script & automatically reload it
;   Somehow the MsgBox doesn't work, so I use ]t to test if the change has been updated
; MsgBox,1,Title: dbkeys.ahk, This AHK has been reloaded, 100
:*:]t:: Test okay at 2/6/2022 11:27 PM

!r::
Send, ^s ; To save a changed script
Sleep, 300 ; give it time to save the script
Reload
MsgBox,1,Title: dbkeys.ahk, This AHK has been reloaded, 10
Return
;------------------------------------------------------------------------------------------------------------


;------------------------------------------------------------------------------------------------------------
; Win+z to Load up menu
#z::Menu, MyMenu, Show
;------------------------------------------------------------------------------------------------------------

;------------------------------------------------------------------------------------------------------------
; Database related hotstrings
::sl::SELECT`    ; SELECT is the most frequently so surely we need to automate it!
;------------------------------------------------------------------------------------------------------------



;------------------------------------------------------------------------------------------------------------
; Other utilities
:*:]d::  ; This hotstring replaces "]d" with the current date and time via the commands below.
FormatTime, CurrentDateTime,, d/M/yyyy h:mm tt  ; It will look like 2/6/2022 11:32 PM
SendInput %CurrentDateTime%
return
;------------------------------------------------------------------------------------------------------------

;Email := {"1-Thanks"       : "test1"
;        , "2-No thanks"    : "test2"}
;Sub   := {"3-Thanks again" : "test3"}
;For menuItem, string in Sub
; Menu, Sub, Add, %menuItem%, MenuHandler2
;For menuItem, string in Email
; Menu, Email, Add, %menuItem%, MenuHandler2
;Menu, Email, Add, Click for submenu, :Sub
;
;#z::Menu, Email, Show
;
;MenuHandler2:
;MsgBox, % %A_ThisMenu%[A_ThisMenuItem]
;Return


; Email := {"1-Thanks"       : ["test1", 1, "www.google.com"]
;         , "2-No thanks"    : ["test2", 2, "black cars"]}
; Sub   := {"3-Thanks again" : ["test3", 3, "http://www.autohotkey.com/"]}
; For k, menuName in ["Sub", "Email"]
;  For menuItem, string in %menuName%
;   Menu, %menuName%, Add, %menuItem%, MenuHandler
; Menu, Email, Add, Click for submenu, :Sub
; 
; #z::Menu, Email, Show
; 
; MenuHandler:
; number := %A_ThisMenu%[A_ThisMenuItem].2, app := %A_ThisMenu%[A_ThisMenuItem].3
; If !FileExist(app) {
;  If !Instr(app, "://")
;   app := "http://" (Instr(app, ".") ? app : "www.google.com/search?q=" StrReplace(app, " ", "+"))
;  app = chrome.exe %app% --new-window
; }
; MsgBox, 64, % %A_ThisMenu%[A_ThisMenuItem].1, Number = %number%`n`nString = %app%
; Run, %app%
; Return
;--------------------------------------------------------------------------------------------------------------