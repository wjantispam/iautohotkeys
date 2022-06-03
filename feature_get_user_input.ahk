
; _USERINPUT_ will be replaced later with actual userinput
;to add more entires it's just menuItems[MENU_ITEM_NAME] := COMMAND
menuItems := []
Top_10 := "select * from _USERINPUT_`nlimit 10;"
menuItems["Top 10 rows"] := Top_10   ;you may need to replace `n with {enter} depending on what you are sending to 
Total_count := "SELECT COUNT(*) FROM _USERINPUT_;"
menuItems["Total count"] := Total_count 

For menuItem,_ in menuItems
    Menu, menuItems, Add, %menuItem%, MenuHandler
Menu, MyMenu, Add, Click for DB Stats, :menuItems

return ;tells the script to go idle and wait for user input


MenuHandler:
if (!ErrorLevel) {
	if (getDB(userInput)) {
		command := % %A_ThisMenu%[A_ThisMenuItem] ;get the command string from the menuItems array
		sendinput % RegExReplace(command,"_USERINPUT_",userInput)   ;send the command but also try and replace _USERINPUT_ with actual user input
	}
}
Return


+^t::Menu, MyMenu, Show

;byref UserInput means it's treated as input and output variable, so it gets updated in this function and returned as well
getDB(byref UserInput) {
    InputBox, UserInput, Database, Enter database key
    if (ErrorLevel) {
        MsgBox, CANCEL was pressed.
		return 0
	}
    return 1
}
