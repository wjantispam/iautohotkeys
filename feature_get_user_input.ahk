; I have a menu that has selections of sql queries
; some sql that takes user's input
; consider there are several sql queries the menu is created in a loop
; once selected the menu item it should send the sql to the screen
; I would expect it asks user's for input when needed
; the Problem is that the code asks user's input when construct the menu
; instead at the time of selecting the menu item
getDB() {
    InputBox, UserInput, DB Instance, Enter DB Instance name
    if ErrorLevel
        MsgBox, CANCEL was pressed.
    return %UserInput%
}

Top_10 := "
(
    select * from " getDB() " 
    limit 10;
)"

Total_Count := "SELECT COUNT(*) FROM Test;"
Sub := {"Top 10 rows"  : Top_10
        ,"Total count" : Total_Count}

For menuItem, string in Sub
    Menu, Sub, Add, %menuItem%, % GetSql
    ;Menu, Sub, Add, %menuItem%, MenuHandler
Menu, MyMenu, Add, Click for DB Stats, :Sub


MenuHandler:
    menu := A_ThisMenu
    item := %string%
Return

MenuHandler2:
;if ! ErrorLevel
    SendInput % %A_ThisMenu%[A_ThisMenuItem]
Return

;if ! ErrorLevel
;    SendInput % "SQL: " . sql
;return
+^t::Menu, MyMenu, Show