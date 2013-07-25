/*****************************************************************************/
call RxFuncAdd "SysLoadFuncs", "RexxUtil", "SysLoadFuncs"
call SysLoadFuncs
call SysCls
 
say "Please enter the full pathname for the WPSWizard INI File:"
pull IniFile
say "INI file: "||IniFile
say ""
say "Delete the 'gcalendargadget' application from the INI file?"
say "Press Y (and Enter) to continue ..."
pull answer
if answer = "Y" then do
	/* Application: gcalendargadget */
	say "Deleting application: gcalendargadget"
	result = SysIni(IniFile, 'gcalendargadget', 'DELETE:')

	if result \= "" then say "Error deleting application"

	say " "
	say "Finished - press any key to exit..."
	pull answer
end
 
call SysCls
 
/*****************************************************************************/
