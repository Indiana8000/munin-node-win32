' Script to monitor disk usage.
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
		Wscript.Echo "graph_title Filesystem usage (in %)"
		Wscript.Echo "graph_args --upper-limit 100 -l 0"
		Wscript.Echo "graph_vlabel %"
		Wscript.Echo "graph_category disk"
		Wscript.Echo "graph_info This graph shows disk usage on the machine."

		strComputer = "."
		Set objWMIService = GetObject("winmgmts:\\" & strComputer & "\root\cimv2")
		Set colItems = objWMIService.ExecQuery ("Select * From Win32_LogicalDisk WHERE DriveType = 3 OR DriveType = 4")
		For Each objItem in colItems
			tmp = left(objItem.DeviceID,1)
			Wscript.Echo tmp & ".label " & objItem.DeviceID
			Wscript.Echo tmp & ".info " & objItem.DeviceID & " (" & objItem.FileSystem & ") " & objItem.VolumeName
			Wscript.Echo tmp & ".warning 92"
			Wscript.Echo tmp & ".critical 98"
		Next
	end if
else
	strComputer = "."
	Set objWMIService = GetObject("winmgmts:\\" & strComputer & "\root\cimv2")
	Set colItems = objWMIService.ExecQuery ("Select * From Win32_LogicalDisk WHERE DriveType = 3 OR DriveType = 4")
	For Each objItem in colItems
		Wscript.Echo left(objItem.DeviceID,1) & ".value " & Round((objItem.Size - objItem.FreeSpace) * 100 / objItem.Size,0)
	Next
end if