' Script to monitor pagefile usage.
'
' Author: (c) Andreas Kreisl
' http://www.bluepaw.de/
' 
' This work is licensed under a Creative Commons Attribution-Noncommercial-Share Alike 3.0 License
' For all details visit http://creativecommons.org/licenses/by-nc-sa/3.0/

if WScript.Arguments.Count <> 0 then
	if WScript.Arguments.Item(0) = "autoconfig" then
		echo "yes"
	end if
	if WScript.Arguments.Item(0) = "config" then
		echo "No idea how to display this informations ..."
	end if
else
	strComputer = "."
	Set objWMIService = GetObject("winmgmts:\\" & strComputer & "\root\cimv2")
	
	Set colItems = objWMIService.ExecQuery ("Select * From Win32_PageFile")
	For Each objItem in colItems
		Wscript.Echo "Name " & objItem.name
		Wscript.Echo "FileSize " & (objItem.FileSize / 1024 / 1024)
	
	    Set colItems2 = objWMIService.ExecQuery("SELECT * From Win32_PageFileSetting WHERE Name = '" & Replace(objItem.name, "\", "\\") & "'")
	        For Each objItem2 In colItems2
			Wscript.Echo "InitialSize " & objItem2.InitialSize
			Wscript.Echo "MaximumSize " & objItem2.MaximumSize
		next
	
	    Set colItems2 = objWMIService.ExecQuery("Select * From Win32_PageFileUsage WHERE Name = '" & Replace(objItem.name, "\", "\\") & "'")
	        For Each objItem2 In colItems2
			Wscript.Echo "AllocatedBaseSize " & objItem2.AllocatedBaseSize
			Wscript.Echo "CurrentUsage " & objItem2.CurrentUsage
		next
	Next
end if
