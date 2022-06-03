; I have a menu and each item represents different sql queries
; some queries that takes user's input
; consider there are several queries I created the menu via a loop
; once user selects a query it should send the final query version as text
; I would expect it asks user for input when needed
; But it has a bug that it asks user's input when constructing the menu
; instead at the runtime when choosing the query.
getDB() {
    InputBox, UserInput, Database, Enter database key
    if ErrorLevel
        MsgBox, CANCEL was pressed.
    return %UserInput%
}

Top_10 := "
(
    select * from " getDB() " 
    limit 10;
)"

Total_Count := "SELECT COUNT(*) FROM " getDB() ";"
Sub := {"Top 10 rows"  : Top_10
        ,"Total count" : Total_Count}
;;; HERE IS THE PROBLEM
;;; IT ASKS USER INPUT TOO EARLY
For menuItem, string in Sub
    Menu, Sub, Add, %menuItem%, MenuHandler
Menu, MyMenu, Add, Click for DB Stats, :Sub

MenuHandler:
if ! ErrorLevel
    SendInput % %A_ThisMenu%[A_ThisMenuItem]
Return

;if ! ErrorLevel
;    SendInput % "SQL: " . sql
;return
+^t::Menu, MyMenu, Show