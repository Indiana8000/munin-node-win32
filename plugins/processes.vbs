' Script to monitor Processes.
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
		Wscript.Echo "graph_title Processes"
		Wscript.Echo "graph_args --base 1000 -l 0"
		Wscript.Echo "graph_vlabel Count"
		Wscript.Echo "graph_category system"

		Wscript.Echo "processes.label Processes"
		Wscript.Echo "threads.label Threads"
	end if
else
	strComputer = "."
	Set objWMIService = GetObject("winmgmts:\\" & strComputer & "\root\cimv2")
	Set colItems = objWMIService.ExecQuery ("Select * From Win32_PerfFormattedData_PerfOS_System")
	For Each objItem in colItems
		Wscript.Echo "processes.value " & objItem.Processes
		Wscript.Echo "threads.value " & objItem.Threads
	Next
end if
