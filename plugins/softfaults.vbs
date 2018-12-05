' Script to monitor swapping.
'
' Author: (c) Andreas Kreisl
' http://www.bluepaw.de/
' 
' This work is licensed under a Creative Commons Attribution-Noncommercial-Share Alike 3.0 License
' For all details visit http://creativecommons.org/licenses/by-nc-sa/3.0/

if WScript.Arguments.Count <> 0 then
	if WScript.Arguments.Item(0) = "autoconfig" then
		Wscript.Echo "yes"
	end if
	if WScript.Arguments.Item(0) = "config" then
		Wscript.Echo "graph_title Soft Faults"
		Wscript.Echo "graph_args -l 0 --base 1000"
		Wscript.Echo "graph_vlabel Soft Faults per ${graph_period}"
		Wscript.Echo "graph_category system"

		Wscript.Echo "PageSoftFaults.label SoftFaults"
		Wscript.Echo "PageSoftFaults.type DERIVE"

	end if
else
	strComputer = "."
	Set objWMIService = GetObject("winmgmts:\\" & strComputer & "\root\cimv2")
	Set colItems = objWMIService.ExecQuery ("Select * From Win32_PerfRawData_PerfOS_Memory")
	For Each objItem in colItems
		Wscript.Echo "PageSoftFaults.value " & (objItem.PageFaultsPerSec - objItem.PageReadsPerSec - objItem.PageWritesPerSec) 'not in place, hard and soft error
	Next
end if