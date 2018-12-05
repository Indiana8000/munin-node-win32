' Script to monitor HDD temperature.
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
		Wscript.Echo "graph_title HDD temperature"
		Wscript.Echo "graph_args --base 1000 -l 0"
		Wscript.Echo "graph_vlabel °C"
		Wscript.Echo "graph_category sensors"

		Set objWMIService = GetObject("winmgmts:\\.\root\cimv2")
		Set colItems = objWMIService.ExecQuery ( "SELECT * FROM Win32_DiskDrive")
		For Each objItem in colItems
			i = instr(objItem.DeviceID, "PHYSICALDRIVE") + 13
			t = mid(objItem.DeviceID,i)
			Wscript.Echo "hdd" & t & ".label " & objItem.Caption
			Wscript.Echo "hdd" & t & ".warning 55"
			Wscript.Echo "hdd" & t & ".critical 65"
		Next
	end if
else
	Set WshShell = CreateObject("WScript.Shell")

	Set objWMIService = GetObject("winmgmts:\\.\root\cimv2")
	Set colItems = objWMIService.ExecQuery ( "SELECT * FROM Win32_DiskDrive")
	For Each objItem in colItems
		i = instr(objItem.DeviceID, "PHYSICALDRIVE") + 13
		t = mid(objItem.DeviceID,i)

		Set oExec = WshShell.Exec("smartctl.exe -A sd" & chr(asc("a")+t))
		Do While oExec.Status = 0
		     WScript.Sleep 100
		Loop
		input = ""
		Do While Not oExec.StdOut.AtEndOfStream
			input = input & oExec.StdOut.Read(1)
		Loop

		i = instr(input, vbCrLf & "194 ") + 2
		input = mid(input,i)
		i = instr(input, vbCrLf) - 1
		input = left(input,i)
		i = InstrRev(input," ") + 1
		input = mid(input,i)
		if input <> "Allen" then
			Wscript.Echo "hdd" & t & ".value " & input
		end if
	Next
	Set shell = Nothing

end if
