' Script to monitor uptime.
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
		Wscript.Echo "graph_title Uptime"
		Wscript.Echo "graph_args --base 1000 -l 0"
		Wscript.Echo "graph_vlabel uptime in days"
		Wscript.Echo "uptime.label uptime"
		Wscript.Echo "uptime.draw AREA"
	end if
else
	strComputer = "."
	Set objWMIService = GetObject("winmgmts:\\" & strComputer & "\root\cimv2")
	Set colItems = objWMIService.ExecQuery ("Select * From Win32_PerfFormattedData_PerfOS_System")
	For Each objItem in colItems
		Wscript.Echo "uptime.value " & Replace(Round((objItem.SystemUpTime/86400),2),",",".")
	Next
end if
