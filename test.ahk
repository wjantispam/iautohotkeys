
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
    WHERE table_schema=_USERINPUT_;
)"

dbmenuItems := []
dbmenuItems["Table sizes"] := Table_Sizes
dbmenuItems["Engine sizes"] := Engine_Sizes

For menuItem, _ in dbmenuItems
    Menu, dbmenuItems, Add, %menuItem%, MenuHandler
Menu, MyMenu, Add, Click for DB Stats, :dbmenuItems


return ;tells the script to go idle and wait for user input

MenuHandler:
    MsgBox % %A_ThisMenu%[A_ThisMenuItem]
    ;MsgBox You selected %A_ThisMenuItem% from menu %A_ThisMenu%.
    if InStr(%A_ThisMenu%[A_ThisMenuItem], "_USERINPUT_")
        MsgBox We need inputs
    Else
        MsgBox We can just send to console

Return

+^t::Menu, MyMenu, Show

;------------------------------------------------------------------------------------------------------------
; Alt+r to Save this script & automatically reload it
;   Somehow the MsgBox doesn't work, so I use ]t to test if the change has been updated
; MsgBox,1,Title: dbkeys.ahk, This AHK has been reloaded, 100
:*:]t:: Test okay at 2/6/2022 11:27 PM

#!r::
Send, ^s ; To save a changed script
Sleep, 300 ; give it time to save the script
Reload
MsgBox,1,Title: dbkeys.ahk, This AHK has been reloaded, 10
Return
;------------------------------------------------------------------------------------------------------------
