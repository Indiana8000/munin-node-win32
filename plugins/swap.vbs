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
		Wscript.Echo "graph_title Swap in/out"
		Wscript.Echo "graph_args -l 0 --base 1000"
		Wscript.Echo "graph_vlabel pages per ${graph_period} in (-) / out (+)"
		Wscript.Echo "graph_category system"
		Wscript.Echo "graph_order PagesInput PagesOutput PageReads PageWrites"

		Wscript.Echo "PagesInput.label Pages"
		Wscript.Echo "PagesInput.type DERIVE"
		Wscript.Echo "PagesInput.graph no"
		Wscript.Echo "PagesInput.draw AREA"
		Wscript.Echo "PagesOutput.label Pages"
		Wscript.Echo "PagesOutput.type DERIVE"
		Wscript.Echo "PagesOutput.negative PagesInput"
		Wscript.Echo "PagesOutput.draw AREA"

		Wscript.Echo "PageReads.label Count"
		Wscript.Echo "PageReads.type DERIVE"
		Wscript.Echo "PageReads.graph no"
		Wscript.Echo "PageWrites.label Count"
		Wscript.Echo "PageWrites.type DERIVE"
		Wscript.Echo "PageWrites.negative PageReads"
	end if
else
	strComputer = "."
	Set objWMIService = GetObject("winmgmts:\\" & strComputer & "\root\cimv2")
	Set colItems = objWMIService.ExecQuery ("Select * From Win32_PerfRawData_PerfOS_Memory")
	For Each objItem in colItems
		Wscript.Echo "PageReads.value " & objItem.PageReadsPerSec 'count
		Wscript.Echo "PageWrites.value " & objItem.PageWritesPerSec 'count
		Wscript.Echo "PagesInput.value " & objItem.PagesInputPerSec 'amount
		Wscript.Echo "PagesOutput.value " & objItem.PagesOutputPerSec 'amount
	Next
end if