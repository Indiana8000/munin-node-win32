' Script to monitor memory usage.
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
		Wscript.Echo "graph_title Memory usage"
		Wscript.Echo "graph_args --base 1024 -l 0 --vertical-label Bytes"    ' --upper-limit 2126540800"
		Wscript.Echo "graph_category system"
		Wscript.Echo "graph_info This graph shows what the machine uses its memory for."
		Wscript.Echo "graph_order apps cached free swap"

		Wscript.Echo "apps.label apps"
		Wscript.Echo "apps.draw AREA"
		Wscript.Echo "apps.info Memory used by user-space applications."
		Wscript.Echo "cached.label cache"
		Wscript.Echo "cached.draw STACK"
		Wscript.Echo "cached.info Parked file data (file content) cache."
		Wscript.Echo "free.label unused"
		Wscript.Echo "free.draw STACK"
		Wscript.Echo "free.info Wasted memory. Memory that is not used for anything at all."
		Wscript.Echo "swap.label swap"
		Wscript.Echo "swap.draw STACK"
		Wscript.Echo "swap.info Swap space used."
	end if
else
	strComputer = "."
	Set objWMIService = GetObject("winmgmts:\\" & strComputer & "\root\cimv2")

	Set colItems = objWMIService.ExecQuery ("Select * From Win32_ComputerSystem")
	For Each objItem in colItems
		TotalPhysicalMemory = objItem.TotalPhysicalMemory
	next

	Set colItems = objWMIService.ExecQuery ("Select * From Win32_PerfFormattedData_PerfOS_Memory")
	For Each objItem in colItems
		Wscript.Echo "apps.value " & (TotalPhysicalMemory - objItem.AvailableBytes - objItem.CacheBytes)
		Wscript.Echo "cached.value " & objItem.CacheBytes
		Wscript.Echo "free.value " & objItem.AvailableBytes
	Next

	swap = 0
	Set colItems = objWMIService.ExecQuery ("Select * From Win32_PageFile")
	For Each objItem in colItems
	    Set colItems2 = objWMIService.ExecQuery("Select * From Win32_PageFileUsage WHERE Name = '" & Replace(objItem.name, "\", "\\") & "'")
	        For Each objItem2 In colItems2
			swap = swap + objItem2.CurrentUsage
		next
	Next
	Wscript.Echo "swap.value " & (swap * 1024 * 1024)
end if
