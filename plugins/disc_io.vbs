' Script to monitor physical disc io.
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
		Wscript.Echo "graph_title IOstat"
		Wscript.Echo "graph_args --base 1024"
		Wscript.Echo "graph_vlabel bytes per ${graph_period} read (-) / written (+)"
		Wscript.Echo "graph_category disk"
		Wscript.Echo "graph_info This graph shows the physical disc io."

		strComputer = "."
		Set objWMIService = GetObject("winmgmts:\\" & strComputer & "\root\cimv2")

		Set colItems = objWMIService.ExecQuery ("Select * From Win32_PerfRawData_PerfDisk_PhysicalDisk WHERE Name <> '_Total'")
		For Each objItem in colItems
			tmp = "io" & left(objItem.Name,1)
			Wscript.Echo tmp & "_read.label "& objItem.Name
			Wscript.Echo tmp & "_read.type COUNTER"
			Wscript.Echo tmp & "_read.graph no"
			Wscript.Echo tmp & "_write.label " & objItem.Name
			Wscript.Echo tmp & "_write.type COUNTER"
			Wscript.Echo tmp & "_write.negative " & tmp & "_read"

		Next
	end if
else
	strComputer = "."
	Set objWMIService = GetObject("winmgmts:\\" & strComputer & "\root\cimv2")

	Set colItems = objWMIService.ExecQuery ("Select * From Win32_PerfRawData_PerfDisk_PhysicalDisk WHERE Name <> '_Total'")
	For Each objItem in colItems
		tmp = "io" & left(objItem.Name,1)
		Wscript.Echo tmp & "_read.value " & objItem.DiskReadBytesPerSec
		Wscript.Echo tmp & "_write.value " & objItem.DiskWriteBytesPerSec

		'Wscript.Echo "SplitIOPerSec " & objItem.SplitIOPerSec
	Next
end if
